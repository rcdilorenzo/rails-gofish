# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    password 'password'
    password_confirmation 'password'
    email 'user@example.com'
    screen_name 'winnerjohn65'
  end
end
