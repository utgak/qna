require 'rails_helper'

shared_examples 'votable controller' do
  describe 'vote' do
    let!(:votable) { create(controller.controller_name.singularize) }
    before { login(create(:user)) }

    it 'vote_up' do
      patch :vote_up, params: { id: votable, format: :json }

      expect(votable.voting_result).to eq 1
      expect(JSON.parse(response.body)['result']).to eq 1
    end

    it 'vote_down' do
      patch :vote_down, params: { id: votable, format: :json }

      expect(votable.voting_result).to eq(-1)
      expect(JSON.parse(response.body)['result']).to eq(-1)
    end

    it 'revote' do
      patch :vote_down, params: { id: votable, format: :json }
      expect(votable.voting_result).to eq(-1)
      patch :vote_up, params: { id: votable, format: :json }
      expect(votable.voting_result).to eq(1)
      expect(JSON.parse(response.body)['result']).to eq(1)
    end

    it 'vote_second_time' do
      patch :vote_down, params: { id: votable, format: :json }
      patch :vote_down, params: { id: votable, format: :json }

      expect(JSON.parse(response.body)[0]).to eq 'User have already voted'
    end
  end

  describe 'not vote' do
    let(:votable) { create(controller.controller_name.singularize) }
    before { login(votable.user) }

    it 'user cannot vote for his votable' do
      patch :vote_up, params: { id: votable, format: :json }

      expect(votable.voting_result).to eq 0
    end
  end
end
