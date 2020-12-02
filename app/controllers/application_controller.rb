class ApplicationController < ActionController::API

  def authentication_service
    TopTen::Application.config.authentication_service.constantize
  end
end
