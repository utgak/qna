require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'votable controller'

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }
    context 'author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      let!(:user) { create(:user) }
      let!(:answer) { create(:answer) }
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer.id, format: :js }
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    before {login(answer.user)}

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    context 'author of question' do
      let!(:answer) { create(:answer, question: question) }
      before { login(question.user) }
      it 'mark answer as the best' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render best view' do
        patch :best, params: { id: answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'not author of question' do
      let!(:answer) { create(:answer, question: question) }
      before { login(create(:user)) }
      it 'mark answer as the best' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to eq false
      end

      it 'render best view' do
        patch :best, params: { id: answer, format: :js }
        expect(response).to have_http_status :forbidden
      end
    end

    context 'unauthorized user' do
      let!(:answer) { create(:answer, question: question) }
      it 'mark answer as the best' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
