class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: %i[create publish_comment]

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    publish_comment
  end
  
  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "questions/#{@commentable.is_a?(Question) ? @commentable.id : @commentable.question.id}/comments",
      { comment: @comment, email: @commentable.user.email, author_id: current_user.id }
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    else
      @commentable = Answer.find(params[:answer_id])
    end
  end
end
