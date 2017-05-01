class SearchesController < ApplicationController
  before_action :require_login, only: :index
  
  def index
  end

  def create
    data = Darksky_Client.forecast(params[:lat], params[:long])
    @user = current_user
    search_info = {
      lat: params[:lat],
      long: params[:long],
      zipcode: params[:zipcode]
    }
    # Note: implement catching for Darksky's shenanigans
    if !!@user
      search = @user.searches.new(search_info)
      if search.save
        render :json => { message: 'Successfully stored search', status: :created, data: data }
      else
        render :json => { message: 'Save of search failed', status: :unprocessable_entity, data: data }
      end
    else
      render :json => { message: 'Returning search results for anonymous user', status: :partial_content, data: data}
    end
  end

end
