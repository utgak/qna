class AnswersController < ApplicationController
  before_action :find_question, only: %i[create new]
  before_action :find_answer, only: :show

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path(@answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit( :body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
