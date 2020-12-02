class ApplicationController < ActionController::API

  def authentication_service
    TopTen::Application.config.authentication_service.constantize
  end

  def current_user
    @current_user ||= User.find_by(name: params[:user_name])
  end

  def ensure_request_decoded
    authentication_service.decode_request_signature!(
      strong_params: strong_params,
      authorization: request.authorization,
      user: current_user
    )
  end
end
