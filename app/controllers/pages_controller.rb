class PagesController < ApplicationController 
  def front 
    redirect_to home_path if logged_in?
  end

  def invalid_token; end
end