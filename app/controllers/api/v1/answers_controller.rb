class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[show update destroy]
  authorize_resource

  def index
    render json: Question.find(params[:question_id]).answers
  end

  def show
    @answer = Answer.with_attached_files.find(params[:id])
    render json: @answer
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: {deleted: :successful}
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question = Question.find(params[:question_id])
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: [:name, :url],)
  end
end
