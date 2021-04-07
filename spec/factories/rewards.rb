FactoryBot.define do
  factory :reward do
    img { Rack::Test::UploadedFile.new(Rails.root.join('storage', 'img.png'), 'image/png') }
    name { "factory reward name" }
    question
    user { nil }
  end
end
