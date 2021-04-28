require 'rails_helper'

RSpec.describe QuestionSubscription do
  let(:answer) { create(:answer) }
  let(:users) { create_list(:user, 4) }
  before { answer.question.subscribers << users }

  it 'sends daily digest to all users' do
    answer.question.subscribers.each do |user|
      expect(QuestionSubscriptionMailer).to receive(:new_answer).with(answer, user).and_call_original
    end
    subject.send_answer(answer)
  end
end
