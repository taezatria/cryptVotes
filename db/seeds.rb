# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(
  name: "Admin CryptVotes",
  idNumber: "1234567890",
  email: "admin@cryptvotes.com",
  username: "cryptadmin",
  password: "cryptadmin"
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