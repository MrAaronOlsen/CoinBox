user = User.create( username: 'fuzzylumpkin',
                    password: 'password' )
profile = Profile.create( first_name: 'Fuzzy',
                          last_name: 'Lumpkin',
                          user: user )

10.times { user.coins << Coin.create(denom: 3) }
15.times { user.coins << Coin.create(denom: 2) }
20.times { user.coins << Coin.create(denom: 1) }
30.times { user.coins << Coin.create(denom: 0) }

100.times { Reward.create(name: Faker::Beer.name,
                         desc: Faker::ChuckNorris.fact,
                         cost: rand(0..1000) ) }