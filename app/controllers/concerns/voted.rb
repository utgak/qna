module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)
    return_json
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)
    return_json
  end

  private

  def return_json
    respond_to do |format|
      format.json do
        if @votable.errors.empty?
          render json: {result: @votable.voting_result, id: @votable.id, class: controller_name}
        else
          render json: @votable.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
