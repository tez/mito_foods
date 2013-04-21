# encoding: utf-8

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }
    sequence(:description) { |n| "Genre description #{n}" }
  end

  factory :area do
    sequence(:name) { |n| "Area #{n}" }
    sequence(:description) { |n| "Area description #{n}" }
  end
end