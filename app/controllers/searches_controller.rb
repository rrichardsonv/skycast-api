class SearchesController < ApplicationController
  before_action :require_login, only: :index
  
  def index
    @user = current_user
    data = @user.queries
    unless data.length === 0
      render :json => { message: 'Successfully loaded searches belonging to user', data: data }, status: :ok
    else
      render :head => { message: 'No searches belonging to user' }, status: :no_content
    end
  end

  def create
    data = Darksky_Client.forecast(params[:lat], params[:long])
    @user = current_user
    search_info = {
      lat: params[:lat],
      long: params[:long],
      zipcode: params[:zipcode]
    }
    if !!data
      if !!@user
        search = @user.searches.new(search_info)
        if search.save
          render :json => { message: 'Successfully stored search', data: data }, status: :created
        else
          render :json => { message: 'Save of search failed', data: data }, status: :unprocessable_entity
        end
      else
        render :json => { message: 'Returning search results for anonymous user', data: data}, status: :partial_content
      end
    else
      render :head => { message: 'No response'}, status: :bad_gateway
    end
  end

end
