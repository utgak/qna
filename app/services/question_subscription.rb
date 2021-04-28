class QuestionSubscription
  def send_answer(answer)
    answer.question.subscribers.each do |user|
      QuestionSubscriptionMailer.new_answer(answer, user)
    end
  end
end
