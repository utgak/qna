class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def subscribe
    authorize! :subscribe,
    @question = Question.find(params[:question_id])
    authorize! :subscribe, @question

    @subscription = @question.subscribers << current_user

    redirect_to @question, notice: "You successfully subscribed"
  end

  def unsubscribe
    @question = Question.find(params[:question_id])
    authorize! :unsubscribe, @question

    @subscription = QuestionsUser.where(users: current_user, questions: @question).first
    @subscription.destroy

    redirect_to @question, notice: "You successfully unsubscribed"
  end
end
