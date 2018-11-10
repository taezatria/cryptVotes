require 'jsonrpc'
require 'opssl'

$redis = Redis::Namespace.new("cryptVotes", :redis => Redis.new)
$cold = Multichain::JsonRPC.new("http://multichainrpc:CHDVVFzyJsvPQJaZPfEuvm3i9qWvRzLJDq7YR5m3Byix@localhost:45313")
$hot = Multichain::JsonRPC.new("http://multichainrpc:9eHahUSWh6zUUTiVAoi1rpv2RKvvEJpjKm3S9aodkwcS@192.168.37.189:45313")
$opssl = OpSSL::OpSSL.new
$redis.set("defaultpassphrase","foobar")
$redis.set("nodepassphrase","cryptvotechain")