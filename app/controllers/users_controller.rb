class UsersController < ApplicationController
  def create
    user      = UserService.create!(name: strong_params[:name])
    blueprint = UserBlueprint.render(user)
    render json: blueprint, status: 201
  end

  def strong_params
    params.permit(:name)
  end
end
