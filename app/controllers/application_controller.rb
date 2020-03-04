class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_quick_contracts

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def after_sign_in_path_for(_resource)
    '/my-report'
  end

  private

  def set_quick_contracts
    @quick_contracts = if current_user
                         Current_user.reports
                           .order(created_at: :desc)
                           .first&.contracts&.order(:name) || []
                       else
                         []
                       end
  end
end
