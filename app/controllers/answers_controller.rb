class AnswersController < ApplicationController
  include Voted

  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy best]
  before_action :authenticate_user!

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    publish_answer
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    @answer.mark_as_best if current_user&.author_of?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{@answer.question.id}/answers",
      { answer: @answer, author_id: current_user.id }
    )
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
