require 'jsonrpc'
require 'opssl'

$redis = Redis::Namespace.new("cryptVotes", :redis => Redis.new)
$cold = Multichain::JsonRPC.new("http://multichainrpc:CHDVVFzyJsvPQJaZPfEuvm3i9qWvRzLJDq7YR5m3Byix@localhost:45313")
# $cold = Multichain::JsonRPC.new("http://multichainrpc:H7YhbgdtUPA3BmCiQc9NHTJ8kzAMBEZSzFZFKE45UxY4@localhost:45313")
$hot = Multichain::JsonRPC.new("http://multichainrpc:9eHahUSWh6zUUTiVAoi1rpv2RKvvEJpjKm3S9aodkwcS@192.168.37.189:45313")
$opssl = OpSSL::OpSSL.new
$redis.set("1passphrase","foobar")
$redis.set("nodepassphrase","cryptvotechain")