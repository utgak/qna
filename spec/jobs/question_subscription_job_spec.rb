require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:service) { double('QuestionSubscription') }
  let(:answer) { create(:answer) }

  before do
    answer.question.subscribers << create(:user)
    allow(QuestionSubscription).to receive(:new).and_return(service)
  end

  it 'calls QuestionSubscriptionJob' do
    expect(service).to receive(:send_answer).with(answer)
    QuestionSubscriptionJob.perform_now(answer)
  end
end
