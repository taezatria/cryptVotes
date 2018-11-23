cand = []
elect = []
us = []
def initial
  #Election
  el = []
  el[0] = Election.create(
    name: "Election 1",
    description: "Election 1",
    start_date: DateTime.now - 1.days,
    end_date: DateTime.now + 2.days,
    image: '/assets/default.jpg',
    status: 1
  )
  Multichain::Multichain.setup_election(el[0])
  elect.push el[0].id

  el[1] = Election.create(
    name: "Election 2",
    description: "Election 2",
    start_date: DateTime.now - 1.days,
    end_date: DateTime.now + 2.days,
    image: '/assets/default.jpg',
    status: 1
  )
  Multichain::Multichain.setup_election(el[1])
  elect.push el[1].id

  el[2]= Election.create(
    name: "Election 3",
    description: "Election 3",
    start_date: DateTime.now - 1.days,
    end_date: DateTime.now + 2.days,
    image: '/assets/default.jpg',
    status: 1
  )
  Multichain::Multichain.setup_election(el[2])
  elect.push el[2].id

  #Organizer + Voter
  c = 1
  3.times do |i|
    cand[i] = []
    6.times do |j|
      user = User.create(
        name: "User "+c.to_s,
        idNumber: "m101000"+c.to_s,
        email: "m101000"+c.to_s+"@matt.petra.ac.id",
        phone: "0810100010"+c.to_s
      )
      us.push user.id
      $opssl.genpkey(user.id, "123456")
      $opssl.genpbkey(user.id, "123456")
      $redis.set(user.id.to_s+"passphrase", "123456")
      Multichain::Multichain.new_keypairs(user)
      c+=1
      if j < 3
        Organizer.create(
          user: user,
          election: el[i]
        )
      else
        Candidate.create(
          user: user,
          election: el[i]
        )
        cand[i].push user.id
      end
      Voter.create(
        user: user,
        election: el[i]
      )
    end
  end

  10.times do |j|
    user = User.create(
        name: "User "+c.to_s,
        idNumber: "m101000"+c.to_s,
        email: "m101000"+c.to_s+"@matt.petra.ac.id",
        phone: "0810100010"+c.to_s
      )
      us.push user.id
      $opssl.genpkey(user.id, "123456")
      $opssl.genpbkey(user.id, "123456")
      $redis.set(user.id.to_s+"passphrase", "123456")
      Multichain::Multichain.new_keypairs(user)
      c+=1

      Voter.create(
        user: user,
        election: el[0]
      )
      Voter.create(
        user: user,
        election: el[1]
      )
      Voter.create(
        user: user,
        election: el[2]
      )
  end

end

def vote(user)
  el1 = Election.find elect[0]
  el2 = Election.find elect[1]
  el3 = Election.find elect[2]

  ra1 = SecureRandom.random_number(3) + 1
  ra2 = SecureRandom.random_number(3) + 1
  ra3 = SecureRandom.random_number(3) + 1
  c1 = User.find cand[0][ra1]
  c2 = User.find cand[1][ra2]
  c3 = User.find cand[2][ra3]

  rawdata1 = [c1.id, el1.id, c1.name].join("0x0")
  data1 = rawdata1.each_byte.map { |b| b.to_str(16) }.join
  rawdata2 = [c2.id, el2.id, c2.name].join("0x0")
  data2 = rawdata2.each_byte.map { |b| b.to_str(16) }.join
  rawdata3 = [c3.id, el3.id, c3.name].join("0x0")
  data3 = rawdata3.each_byte.map { |b| b.to_str(16) }.join

  pass = $redis.get(user.id.to_s+"passphrase")
  privkey = $opssl.decrypt(user.id, pass, user.privateKey)

  Multichain::Multichain.prepare_ballot(user)
  Multichain::Multichain.topup(el1, user)
  Multichain::Multichain.vote(el1, user, privkey, data1)

  Multichain::Multichain.prepare_ballot(user)
  Multichain::Multichain.topup(el2, user)
  Multichain::Multichain.vote(el2, user, privkey, data2)

  Multichain::Multichain.prepare_ballot(user)
  Multichain::Multichain.topup(el3, user)
  Multichain::Multichain.vote(el3, user, privkey, data3)
end

initial

User.where(id: us).each do |user|
  Thread.new do
    Rails.application.executor.wrap do
      vote(user)
    end
  end
end