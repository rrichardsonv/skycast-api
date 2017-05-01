class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render :json => {message: 'User successfully created', data: {token: @user.auth_token}}, status: :created
    else
      render :head => { message: 'Creation failed'}, status: :bad_request
    end
  end

  def user_params
      params.require(:user).permit(:email, :password)
  end
end
