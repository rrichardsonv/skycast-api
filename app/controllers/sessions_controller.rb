class SessionsController < ApplicationController
  before_action :require_login, only: :destroy

  def create
    login_params = user_params
    user = User.find_by(email: login_params[:email])
    if !!user && user.authenticate(login_params[:password])
      send_auth_token_for_valid_login_of(user)
    else
      render :head => { message: "Error with your login credentials" }, status: :bad_request
    end
  end

  def destroy
    logout
    render :head => { message: "Logout successful" }, status: :ok
  end
  # LOGOUT is handled client-side

  private

  def send_auth_token_for_valid_login_of(user)
    if user.regenerate_token
      render :json => { message: "Login successful", data: { token: user.auth_token }}, status: :ok
    else
      render :head => { message: "Error with user credentials" }, status: :internal_server_error
    end
  end

  def logout
    current_user.invalidate_token
  end
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
