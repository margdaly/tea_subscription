FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Tea.type }
    region { Faker::Address.country }
    brew_time { Faker::Number.between(from: 3, to: 8) }
  end
end
