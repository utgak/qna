class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
