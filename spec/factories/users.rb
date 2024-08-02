FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
    authentication_token  { Faker::Alphanumeric.alphanumeric(number: 20) }
    name { 'Alex' }
    surname { 'Petrov' }
    language { 'ru' }
    confirmed_at        { 1.day.ago }
  end
end
