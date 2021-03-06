class ApplicationController < ActionController::API
  before_action :verify_access_key
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = '*'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def verify_access_key
    Apikey.exists?({access_key: params[:key]}) || render_unauthorized('Unauthorized access')
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
