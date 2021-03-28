class AnswersController < ApplicationController
  before_action :find_question, only: %i[create]
  before_action :authenticate_user!

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    render 'questions/show'
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
