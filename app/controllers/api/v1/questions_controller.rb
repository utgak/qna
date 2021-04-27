class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    render json: @question
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: {deleted: :successful}
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      render json: @question
    else
      render json: @question.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: [:name, :url],)
  end
end
