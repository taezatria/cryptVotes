require 'net/http'
require 'uri'
require 'json'

module Multichain
  class JsonRPC
    def initialize(service_url)
      @uri = URI.parse(service_url)
    end

    def method_missing(name, *args)
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      resp['result']
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    end

    class JSONRPCError < RuntimeError; end
  end

  class Multichain
    def self.prepare_ballot(user)
      addresses = get_addresses
      multisigaddress = $cold.createmultisig 3, [user.publicKey, addresses["organizer"], addresses["node"]]
      $hot.importaddress multisigaddress["address"]
      $redis.set(user.id.to_s+"redeemScript", multisigaddress["redeemScript"])
      grnt = $hot.grant multisigaddress["address"], "send"
      multisigaddress["address"] if grnt.present?
    end

    def self.topup(el, addr, user)
      tx = $hot.createrawsendfrom el.address, { addr => { "cryptvotecoin": 1 } }, [], "sign"
      #c = $hot.createrawsendfrom addr[0], { b["address"] => {"asset2": 1 } }
      $hot.sendrawtransaction tx
    end
    
    def self.vote(el, addr, user)
      tx1 = $hot.createrawsendfrom addr, { el.address => { "cryptvotecoin": 1 } }
      dtx = $hot.decoderawtransaction tx1
      tx2 = $cold.signrawtransaction dtx, [{"txid": dtx["vin"][0]["txid"], "vout": dtx["vin"][0]["vout"], "scriptPubKey": dtx["vout"][0]["scriptPubKey"]["hex"], "redeemScript": $redis.get(user.id.to_s+"redeemScript")}], [,,]
      #e = $cold.signrawtransaction c, [{"txid": d["vin"][0]["txid"], "vout": d["vin"][0]["vout"], "scriptPubKey": d["vout"][0]["scriptPubKey"]["hex"], "redeemScript": b["redeemScript"]}], [a[0]["privkey"],a[1]["privkey"],a[2]["privkey"]]
      $hot.sendrawtransaction tx2
      $hot.signmessage , tx2["hex"]
      #f = $hot.signmessage a[0]["privkey"], e["hex"]
      $hot.revoke addr, "send"
    end

    def verify(user)
      $hot.verifymessage
      #$hot.verifymessage a[0]["address"], f, e["hex"]
    end

    private

    def self.get_addresses
      org_count = Organizer.all.count
      rnd = SecureRandom.random_number(org_count) + 1
      org_id = Organizer.find(rnd).user_id
      org = User.find(org_id)
      org
    end

    def self.get_election_address(el)
      Election.find_by(id: el, status: 1, deleted_at: nil)
    end
  end
end
