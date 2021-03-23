FactoryBot.define do
  factory :answer do
    question
    body { 'MyString' }

    trait :invalid do
      body { nil }
    end
  end
end
