class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy], raise: false

  def create
    if verify_access_key
      user = User.find_by(email: params[:email])
      if !!user && user.authenticate(params[:password])
        send_auth_token_for_valid_login_of(user)
      else
        render :head => { message: "Error with your login credentials" }, status: :bad_request
      end
    else
      render :head => { message: "Unauthorized login" }, status: :unauthorized
    end
  end

  # def destroy
  #   logout
  #   render :head => { message: "Logout successful" }, status: :ok
  # end

  private

  def send_auth_token_for_valid_login_of(user)
    if user.regenerate_token
      render :json => { message: "Login successful", data: { token: user.auth_token }}, status: :ok
    else
      render :head => { message: "Error with user credentials" }, status: :internal_server_error
    end
  end

  # def logout
  #   current_user.invalidate_token
  # end
end
