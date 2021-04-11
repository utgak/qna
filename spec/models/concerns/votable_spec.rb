require 'rails_helper'

RSpec.shared_examples 'votable' do
  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  it 'vote' do
    3.times { votable.vote_up(create(:user)) }
    expect(votable.votes.where(value: 1).count).to eq 3
  end

  it 'down vote' do
    5.times { votable.vote_down(create(:user)) }
    expect(votable.votes.where(value: -1).count).to eq 5
  end

  it 'result' do
    5.times { votable.vote_up(create(:user)) }
    3.times { votable.vote_down(create(:user)) }
    expect(votable.voting_result).to eq 2
  end
  
  it 'revote' do
    user = (create(:user))
    votable.vote_up(user)
    expect(votable.voting_result).to eq 1
    votable.vote_down(user)
    expect(votable.voting_result).to eq(-1)
  end

  it 'vote 2 times' do
    user = (create(:user))
    votable.vote_up(user)
    votable.vote_up(user)
    expect(votable.errors.full_messages.first).to eq "User have already voted"
  end
end

RSpec.describe Answer do
  it_behaves_like 'votable'
end

RSpec.describe Question do
  it_behaves_like 'votable'
end