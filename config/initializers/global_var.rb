require 'jsonrpc'
require 'opssl'

$redis = Redis::Namespace.new("cryptVotes", :redis => Redis.new)
$cold = Multichain::JsonRPC.new("http://multichainrpc:BBjb5j9Qvcfj8iSMmTwVM7gVkwQPscvaoe9QGt1pLFKq@localhost:45313")
# $cold = Multichain::JsonRPC.new("http://multichainrpc:H7YhbgdtUPA3BmCiQc9NHTJ8kzAMBEZSzFZFKE45UxY4@localhost:45313")
$hot = Multichain::JsonRPC.new("http://multichainrpc:4dHwqcTvLcuK5TmcjQwV9mCjzXzNV1w4aZcq6vBAyZfq@192.168.37.189:45313")
$opssl = OpSSL::OpSSL.new
$redis.set("1passphrase","foobar")
$redis.set("nodepassphrase","cryptvotechain")