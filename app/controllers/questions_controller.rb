class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update edit]

  def index
    @questions = Question.all
  end

  def show
  end

  def edit
  end

  def new
    @question = Question.new
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
    @question = Question.find(params[:id])
    @question.destroy if current_user.author_of?(@question)
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
    params.require(:question).permit(:title, :body, files: [])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
