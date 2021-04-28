require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it "have many attached files" do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'subscriptions' do
    let(:answer) { build(:answer) }

    it 'calls QuestionSubscriptionJob' do
      expect(QuestionSubscriptionJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end

  describe 'mark answer as best' do
    let!(:answer) { create(:answer) }
    it 'check best method' do
      answer.mark_as_best
      expect(answer).to be_best
    end

    it 'check that only one answer is best' do
      question = create(:question)
      user = create(:user)
      2.times { question.answers.create(question: question, user: user, body: 'answer_body') }
      question.answers.first.mark_as_best
      question.answers.last.mark_as_best

      expect(question.answers.where(best: true).length).to eq 1
    end

    it 'check that the best answer is first' do
      question = create(:question)
      user = create(:user)
      2.times { question.answers.create(question: question, user: user, body: 'answer_body') }
      question.answers.last.mark_as_best

      expect(question.answers.first.best).to eq true
    end

    it 'reward user' do
      reward = create(:reward, question: answer.question)
      answer.mark_as_best
      expect(answer.user.rewards.first).to eq reward
    end
  end
end
