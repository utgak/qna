class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionSubscription.new.send_answer(answer)
  end
end
