User.create!(name: "Example User",
        email:"example@raiilstutorial.org",
        password: "foobar",
        password_confirmation: "foobar")

        99.times do |n|
            name = Faker::Name.name
            email = "example-#{n+1}@raiilstutorial.org"
            password = "password"
            User.create!(name: name,
                    email:email,
                    password: password,
                    password_confirmation:password)
        end
