class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
