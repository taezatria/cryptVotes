# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#admin
admin = User.create(
  name: "Admin CryptVotes",
  idNumber: "1234567890",
  email: "admin@cryptvotes.com",
  phone: "000-1234567",
  username: "cryptadmin",
  password: Digest::MD5.hexdigest("cryptadmin"),
  approved: true,
  firstLogin: false
)

admin_right = AccessRight.create(
  name: "Admin"
)

admin_election = Election.create(
  name: "Default",
  description: "default election for admin",
  start_date: DateTime.now,
  end_date: DateTime.now,
  participants: 0,
  image: "image",
  deleted_at: DateTime.now
)

Organizer.create(
  user: admin,
  election: admin_election,
  access_right: admin_right
)

#other user seed
sd = DateTime.now + (SecureRandom.random_number(21)-14).days
ed = DateTime.now + (SecureRandom.random_number(21)-7).days
while ed <= sd do
  sd = DateTime.now + (SecureRandom.random_number(21)-14).days
  ed = DateTime.now + (SecureRandom.random_number(21)-7).days
end
if DateTime.now < sd
  sta = 0
elsif DateTime.now <= ed
  sta = 1
elsif DateTime.now <= (ed + 6.days)
  sta = 2
else
  sta = 3
end

elec1 = Election.create(
  name: SecureRandom.hex(10),
  description: SecureRandom.hex,
  start_date: sd,
  end_date: ed,
  participants: SecureRandom.random_number(100),
  status: sta,
  image: SecureRandom.hex
)
#Multichain::Multichain.setup_election(elec1)
#16fDSG4bhjBtto3PbqPKYoe2ZqhMNMDczRCdKQ

sd = DateTime.now + (SecureRandom.random_number(21)-14).days
ed = DateTime.now + (SecureRandom.random_number(21)-7).days
while ed <= sd do
  sd = DateTime.now + (SecureRandom.random_number(21)-14).days
  ed = DateTime.now + (SecureRandom.random_number(21)-7).days
end
if DateTime.now < sd
  sta = 0
elsif DateTime.now <= ed
  sta = 1
elsif DateTime.now <= (ed + 6.days)
  sta = 2
else
  sta = 3
end

elec2 = Election.create(
  name: SecureRandom.hex(10),
  description: SecureRandom.hex,
  start_date: sd,
  end_date: ed,
  participants: SecureRandom.random_number(100),
  status: sta,
  image: SecureRandom.hex
)
#Multichain::Multichain.setup_election(elec2)
#1gncPC1YXxSd1WDXC4FHrSWYvJe8sroJwZGfr

$opssl.genpkey("default","foobar")
$opssl.genpbkey("default","foobar")

i = 0

10.times do
  address = $cold.createkeypairs[0]
  privkey = $opssl.encrypt("default",address["privkey"])
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5),
    approved: true,
    firstLogin: false,
    username: "coba"+i.to_s,
    password: Digest::MD5.hexdigest("coba"+i.to_s),
    addressKey: address["address"],
    publicKey: address["pubkey"],
    privateKey: privkey
  )
  Voter.create(
    user: user,
    election: elec1
  )
  Voter.create(
    user: user,
    election: elec2
  )
  i+=1
end
4.times do
  address = $cold.createkeypairs[0]
  privkey = $opssl.encrypt("default",address["privkey"])
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5),
    approved: true,
    firstLogin: false,
    username: "coba"+i.to_s,
    password: Digest::MD5.hexdigest("coba"+i.to_s),
    addressKey: address["address"],
    publicKey: address["pubkey"],
    privateKey: privkey
  )
  Candidate.create(
    user: user,
    election: elec1,
    description: SecureRandom.hex,
    image: SecureRandom.hex
  )
  Voter.create(
    user: user,
    election: elec1
  )
  ar = AccessRight.create(name: SecureRandom.hex(3))
  Organizer.create(
    user: user,
    election: elec1,
    access_right: ar
  )
  i+=1
end
4.times do
  address = $cold.createkeypairs[0]
  privkey = $opssl.encrypt("default",address["privkey"])
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5),
    approved: true,
    firstLogin: false,
    username: "coba"+i.to_s,
    password: Digest::MD5.hexdigest("coba"+i.to_s),
    addressKey: address["address"],
    publicKey: address["pubkey"],
    privateKey: privkey
  )
  Candidate.create(
    user: user,
    election: elec2,
    description: SecureRandom.hex,
    image: SecureRandom.hex
  )
  Voter.create(
    user: user,
    election: elec2
  )
  ar = AccessRight.create(name: SecureRandom.hex(3))
  Organizer.create(
    user: user,
    election: elec2,
    access_right: ar
  )
  i+=1
end

org = User.last
org.username = "cobaadmin"
org.password = Digest::MD5.hexdigest("cobaadmin")
org.save

address = $cold.createkeypairs[0]
$opssl.genpkey(org.id+1,"foobar")
$opssl.genpbkey(org.id+1,"foobar")
privkey = $opssl.encrypt(org.id+1,address["privkey"])
user = User.create(
  name: SecureRandom.hex(10), 
  idNumber: SecureRandom.hex(10), 
  email: SecureRandom.hex(10), 
  phone: SecureRandom.hex(5),
  approved: true,
  firstLogin: false,
  username: "cobavoter",
  password: Digest::MD5.hexdigest("cobavoter"),
  addressKey: address["address"],
  publicKey: address["pubkey"],
  privateKey: privkey
)
Voter.create(
  user: user,
  election: elec1
)

c = [{ id: 1, el_id: 2, name: "Candidate nomor 1"},
{ id: 2, el_id: 3, name: "Candidate nomor 1"},
{ id: 3, el_id: 2, name: "Candidate nomor 2"},
{ id: 4, el_id: 3, name: "Candidate nomor 2"},
{ id: 5, el_id: 2, name: "Candidate nomor 3"},
{ id: 6, el_id: 3, name: "Candidate nomor 3"},
{ id: 7, el_id: 3, name: "Candidate nomor 4"}]
#vote result seed
100.times do
  ca = c[SecureRandom.random_number(7)]
  str_ca = ca[:id].to_s + "00" + ca[:el_id].to_s + "00" + ca[:name]
  hex_ca = str_ca.each_byte.map { |b| b.to_s(16) }.join
  VoteResult.create(
    hex: SecureRandom.hex,
    blockHash: SecureRandom.hex,
    txid: SecureRandom.hex,
    data: hex_ca,
    fromAddress: SecureRandom.hex,
    toAddress: SecureRandom.hex,
    amount: SecureRandom.random_number(10)+1,
    confirmation: SecureRandom.random_number(100)+1
  )
end