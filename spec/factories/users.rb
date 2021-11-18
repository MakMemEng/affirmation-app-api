FactoryBot.define do
  factory :user do
    name { 'makmemeng' }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
