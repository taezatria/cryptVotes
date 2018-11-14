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

admin_election = Election.create(
  name: "Default Admin Election",
  description: "default election for organizer",
  start_date: DateTime.now,
  end_date: DateTime.now,
  participants: 0,
  image: "image",
  deleted_at: DateTime.now
)

Organizer.create(
  user: admin,
  election: admin_election,
  admin: true
)