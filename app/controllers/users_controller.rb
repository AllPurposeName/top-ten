class UsersController < ApplicationController
  def create
    user      = UserService.create!(name: strong_params[:name])
    blueprint = UserBlueprint.render(user)
    render json: blueprint, status: 201
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def strong_params
    params.permit(:name)
  end
end
