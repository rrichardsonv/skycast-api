class SearchesController < ApplicationController
  def index
  end

  def create
    raise Darksky_Client.forecast(params[:lat], params[:long]).inspect
  end
end
