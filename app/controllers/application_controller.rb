class ApplicationController < ActionController::API
  before_action :verify_access_key

  def verify_access_key
    Apikey.exists?({access_key: params[:key]})
  end

  def require_login
    authenticate_token || render_unauthorized("You must have an account for that")
  end

  def current_user
    if authenticate_token
      @current_user ||= User.find_by({auth_token: params[:token]})
    end
    @current_user
  end

  def render_unauthorized(message)
    errors = {errors: [{detail: message}]}
    render json: errors, status: :unauthorized
  end

  def authenticate_token
    token = params[:token]
    if user = User.with_unexpired_token(token, 2.days.ago)
      ActiveSupport::SecurityUtils.secure_compare(
                      ::Digest::SHA256.hexdigest(token),
                      ::Digest::SHA256.hexdigest(user.auth_token))
    end
  end
end
