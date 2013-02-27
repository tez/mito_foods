namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_genres
  end
end

def make_users
  User.delete_all
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end

  def make_genres
    Genre.delete_all
    100.times do |n|
      name = Faker::Name.name
      description = Faker::Lorem.sentence(5)
      Genre.create!(name: name,
                    description: description)
    end
  end
end