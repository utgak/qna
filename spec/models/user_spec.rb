require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:questions_users).dependent(:destroy) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'verifies authorship' do
    question = create(:question)

    expect(question.user.author_of?(question)).to eq true
    expect(create(:user).author_of?(question)).to eq false
  end
end
