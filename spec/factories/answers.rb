FactoryBot.define do
  factory :answer do
    question
    user
    body { 'AnswerString' }

    trait :invalid do
      body { nil }
    end
  end
end
