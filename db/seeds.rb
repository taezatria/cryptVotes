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
elec1 = Election.create(
  name: SecureRandom.hex(10),
  description: SecureRandom.hex,
  start_date: DateTime.now,
  end_date: DateTime.now,
  participants: SecureRandom.random_number(100),
  image: SecureRandom.hex
)
elec2 = Election.create(
  name: SecureRandom.hex(10),
  description: SecureRandom.hex,
  start_date: DateTime.now,
  end_date: DateTime.now,
  participants: SecureRandom.random_number(100),
  image: SecureRandom.hex
)

10.times do
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5)
  )
  Voter.create(
    user: user,
    election: elec1
  )
  Voter.create(
    user: user,
    election: elec2
  )
end
4.times do
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5)
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
end
4.times do
  user = User.create(
    name: SecureRandom.hex(10), 
    idNumber: SecureRandom.hex(10), 
    email: SecureRandom.hex(10), 
    phone: SecureRandom.hex(5)
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
end

#vote result seed
