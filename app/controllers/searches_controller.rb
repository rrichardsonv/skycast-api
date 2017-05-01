class SearchesController < ApplicationController
  def index
  end

  def create
    data = Darksky_Client.forecast(params[:lat], params[:long]).inspect
    render :json => { status: 201, data: data }
  end

  def search_params
    params.require('search').permit('token', 'zipcode')
  end
end
