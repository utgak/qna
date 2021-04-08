require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional(true) }

  it { should validate_presence_of :name }

  it "have one attached img" do
    expect(Reward.new.img).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
