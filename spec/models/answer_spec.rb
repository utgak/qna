require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe 'mark answer as best' do
    let!(:answer) { create(:answer) }
    it 'check best method' do
      answer.mark_as_best
      expect(answer.best).to eq true
    end

    it 'check that only one answer is best' do
      question = create(:question)
      user = create(:user)
      2.times { question.answers.create(question: question, user: user, body: 'answer_body') }
      question.answers.first.mark_as_best
      question.answers.last.mark_as_best

      expect(question.answers.where(best: true).length).to eq 1
    end
  end
end
