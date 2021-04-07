require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:link) { create(:link) }
    describe 'DELETE #destroy' do
      context 'author' do
        before { login(link.linkable.user) }
        it 'delete the link' do
          expect { delete :destroy, params: { id: link }, format: :js}.to change(Link, :count).by(-1)
        end
      end

      context 'not author' do
        before { login(create(:user)) }
        it 'delete the link' do
          expect { delete :destroy, params: { id: link }, format: :js}.to_not change(Link, :count)
        end
      end
    end
  end
end
