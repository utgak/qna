require 'rails_helper'

RSpec.describe FileController, type: :controller do
  let(:question) { create(:question) }
  before { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
  describe 'DELETE #destroy' do
    context 'author' do
      before { login(question.user) }
      it 'delete the file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to change(question.files, :count).by(-1)
      end
    end

    context 'not author' do
      before { login(create(:user)) }
      it 'delete the file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to_not change(question.files, :count)
      end
    end
  end
end
