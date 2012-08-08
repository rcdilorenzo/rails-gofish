# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    street "MyString"
    city "MyString"
    state "MyString"
    country "MyString"
    zip 1
  end
end
