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
      multisigaddress = $cold.createmultisig 3 [user.publicKey, addresses["organizer"], addresses["node"]]
      $hot.importaddress multisigaddress["address"]
      $hot.grant 
    end

    def self.topup(user)
      $hot.createrawsendfrom
      $hot.sendrawtransaction
    end
    
    def self.vote(user)
      $hot.createrawsendfrom
      $cold.decoderawtransaction
      $cold.signrawtransaction
      $hot.sendrawtransaction
      $hot.signmessage
      $hot.revoke
    end

    def verify(user)
      $hot.verifymessage
    end

    private

    def self.get_addresses
      org_count = Organizer.all.count
      rnd = SecureRandom.random_number(org_count) + 1
      org_id = Organizer.find(rnd).user_id
      org = User.find(org_id)
      org
    end
  end
end
