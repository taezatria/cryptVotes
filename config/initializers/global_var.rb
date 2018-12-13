require 'jsonrpc'
require 'opssl'

$redis = Redis::Namespace.new("cryptVotes", :redis => Redis.new)
# $cold = Multichain::JsonRPC.new("http://multichainrpc:3nDMi45PmKnM5fJVnZNqEyk3NVkGhTvEs9fqndyiePbc@localhost:45313")
$cold = Multichain::JsonRPC.new("http://multichainrpc:HMLy3zWQxmubAmLdoBfm9VydTkHAWMp3NECq39uKmPnM@localhost:45313")
$hot = Multichain::JsonRPC.new("http://multichainrpc:CUKkwZayL2dyQt1U3YPoJnMQZbNEdadjXuCFk771MrH8@192.168.37.189:45313")
$opssl = OpSSL::OpSSL.new
$redis.set("1passphrase","foobar")
$redis.set("nodepassphrase","cryptvotechain")