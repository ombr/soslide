# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'luc@boissaye.fr'
    password 'super_secret'
  end
end
