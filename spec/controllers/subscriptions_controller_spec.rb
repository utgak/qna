require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "subscribe" do
    before { login(user) }
    it 'creates subscription' do
      expect { post :subscribe, params: { question_id: question }}.to change(QuestionsUser, :count).by(1)
    end
  end

  describe "unsubscribe" do
    before do
      login(user)
      question.subscribers << user
    end

    it 'destroy subscription' do
      expect { delete :unsubscribe, params: { question_id: question }}.to change(QuestionsUser, :count).by(-1)
    end
  end
end
