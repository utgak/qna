class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update edit destroy gon_question]
  before_action :gon_question, only: :show

  authorize_resource

  after_action :publish_question, only: [:create]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @reward = @question.reward
  end

  def edit
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted'
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :update
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url],
                                     reward_attributes: [:name, :img])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      "questions_channel",
    @question
    )
  end

  def gon_question
    gon.question_id = @question.id
  end
end
