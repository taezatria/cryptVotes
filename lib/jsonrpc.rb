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
    COIN = "cryptvotecoin".freeze

    def self.prepare_ballot(user)
      addresses = get_addresses
      multisigaddress = $cold.createmultisig 3, [user.publicKey, addresses[:organizer].publicKey, addresses[:node]["pubkey"]]
      $hot.importaddress multisigaddress["address"]
      $redis.set(user.id.to_s+"redeemScript", multisigaddress["redeemScript"])
      $redis.set(user.id.to_s+"orgid", addresses[:organizer].id)
      grnt = $hot.grant multisigaddress["address"], "send"
      if grnt.present?
        if AddressList.where(address: multisigaddress["address"]).count == 0
          AddressList.create(
            address: multisigaddress["address"]
          )
        end
        $redis.set(user.id.to_s+"multiaddress", multisigaddress["address"])
      end
    end

    def self.topup(el, user)
      $hot.walletpassphrase $redis.get("nodepassphrase"), 5
      addr = $redis.get(user.id.to_s+"multiaddress")
      tx = $hot.createrawsendfrom el.addressKey, { addr => { COIN+el.id.to_s => 1 } }, [], "sign"
      #c = $hot.createrawsendfrom addr[0], { b["address"] => {"asset2": 1 } }
      $hot.sendrawtransaction tx["hex"]
      $hot.walletlock
    end

    def self.vote(el, user, privkey, data)
      orgid = $redis.get(user.id.to_s+"orgid")
      org = User.find(orgid)
      addr = $redis.get(user.id.to_s+"multiaddress")
      if privkey.present? && org.present? && addr.present?
        tx1 = $hot.createrawsendfrom addr, { el.addressKey => { COIN+el.id.to_s => 1 } }, [data]
        dtx = $hot.decoderawtransaction tx1
        scriptPubkey = nil
        dtx["vout"].each do |vout|
          if vout["scriptPubKey"]["addresses"].present?
            scriptPubkey = vout["scriptPubKey"]["hex"] if vout["scriptPubKey"]["addresses"][0] == addr
          end
        end

        passdef = $redis.get(orgid.to_s+"passphrase")
        $hot.walletpassphrase $redis.get("nodepassphrase"), 5
        org_privkey = $opssl.decrypt("default", passdef, org.privateKey)
        node_address = $hot.getaddresses[0]
        node_privkey = $hot.dumpprivkey node_address

        tx2 = $cold.signrawtransaction tx1, [{"txid": dtx["vin"][0]["txid"], "vout": dtx["vin"][0]["vout"], "scriptPubKey": scriptPubkey, "redeemScript": $redis.get(user.id.to_s+"redeemScript")}], [privkey, org_privkey, node_privkey]
        #e = $cold.signrawtransaction c, [{"txid": d["vin"][0]["txid"], "vout": d["vin"][0]["vout"], "scriptPubKey": d["vout"][0]["scriptPubKey"]["hex"], "redeemScript": b["redeemScript"]}], [a[0]["privkey"],a[1]["privkey"],a[2]["privkey"]]
        if tx2["complete"]
          $hot.walletlock
          txid = $hot.sendrawtransaction tx2["hex"]
          digsign = $hot.signmessage privkey, tx2["hex"]
          #f = $hot.signmessage a[0]["privkey"], e["hex"]
          $redis.del(user.id.to_s+"orgid")
          $redis.del(user.id.to_s+"redeemScript")
          adr = AddressList.find_by(address: addr)
          adr.tx = txid
          adr.save
        end
      end
      $hot.revoke addr, "send"
      { txid: txid, digsign: digsign }
    end

    def self.get_tx(txid)
      $hot.getrawtransaction txid, 1
    end

    def self.verify(userid)
      txhex = $redis.get(userid.to_s+"txhex")
      digsign = $redis.get(userid.to_s+"digsign")
      user = User.find_by(id: userid, approved: true, firstLogin: false, deleted_at: nil)
      if txhex.present? && digsign.present? && user.present?
        verifystatus = $hot.verifymessage user.addressKey, digsign, txhex
        #$hot.verifymessage a[0]["address"], f, e["hex"]
        $redis.del(user.id.to_s+"txhex")
        $redis.del(user.id.to_s+"digsign")
      end
      verifystatus
    end

    def self.new_keypairs(user)
      keypair = $cold.createkeypairs
      user.addressKey = keypair[0]["address"]
      user.publicKey = keypair[0]["pubkey"]
      privkey = $opssl.encrypt(user.id, keypair[0]["privkey"])
      user.privateKey = privkey
      user.save
    end

    def self.setup_election(el)
      $hot.walletpassphrase $redis.get("nodepassphrase"), 5
      el.addressKey = $hot.getnewaddress
      grnt = $hot.grant el.addressKey, "send"
      if grnt.present?
        tx = $hot.issue el.addressKey, COIN+el.id.to_s, 10000, 1
        el.save if tx.present?
        $hot.walletlock
      end
    end

    def self.tally_votes(el)
      all_txs = $hot.listaddresstransactions el.addressKey
      all_txs.each do |tx|
        if tx["balance"]["assets"].present? && tx["balance"]["assets"][0]["name"] == COIN+el.id.to_s && tx["balance"]["assets"][0]["qty"] > 0
          data_tx = AddressList.find_by(address: tx["addresses"][0])
          if data_tx.present? && data_tx.tx == tx["txid"] && !data_tx.counted && tx["valid"]
            data_tx.counted = true
            raw = $hot.getrawtransaction txid
            VoteResult.create(
              hex: raw,
              blockHash: tx["blockhash"],
              txid: tx["txid"],
              data: tx["data"][0],
              fromAddress: tx["myaddresses"][0],
              toAddress: tx["addresses"][0],
              amount: tx["balance"]["assets"][0]["qty"],
              confirmation: tx["confirmations"]
            )
            data.save
          end
        end
      end
    end

    private

    def self.get_addresses
      org_count = Organizer.all.count
      rnd = SecureRandom.random_number(org_count) + 1
      org_id = Organizer.find_by(id: rnd, deleted_at: nil).user_id
      org = User.find_by(id: 16, firstLogin: false, deleted_at: nil)
      addr = $hot.getaddresses[0]
      { organizer: org, node: $hot.validateaddress(addr) }
    end
  end
end
