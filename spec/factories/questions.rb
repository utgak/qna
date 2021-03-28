FactoryBot.define do
  factory :question do
    user
    title { 'QuestionString' }
    body { 'QuestionText' }
  end

  trait :invalid do
    body { nil }
  end
end
