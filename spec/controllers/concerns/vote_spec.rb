require 'rails_helper'

RSpec.shared_examples 'votable' do
  describe 'vote' do
    let!(:votable) { create(controller.controller_name.singularize) }
    before { login(create(:user))}

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
end

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'votable'
end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'votable'
end
