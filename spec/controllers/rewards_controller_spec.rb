require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) {create(:user)}
  let(:question) { create(:question) }
  let(:rewards) { create_list(:reward, 2)}
  describe 'GET #index' do

    before do
      user.rewards.push(rewards)
      login(user)
      get :index
    end


    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
