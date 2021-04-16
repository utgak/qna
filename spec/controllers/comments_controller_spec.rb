require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    let(:question) { create(:question) }
    before { login(create(:user)) }
    it 'create comment' do
      expect { post :create, params: { question_id: question, comment: { body: 'comment body' } }, format: :js}.to change(Comment, :count).by(1)
    end
  end
end
