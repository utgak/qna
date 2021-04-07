FactoryBot.define do
  factory :link do
    name { "example" }
    url { "https://example.com/" }
    linkable { create(:question) }

    trait :linkable_answer do
      name { "example" }
      url { "https://example.com/" }
      linkable { create(:answer) }
    end
  end
end
