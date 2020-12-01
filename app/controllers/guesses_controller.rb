class GuessesController < ApplicationController
  def index
    guesses   = Guess.all
    blueprint = GuessBlueprint.render(guesses)
    render json: blueprint
  end

  def create
    guess     = GuessService.guess!(strong_params)
    blueprint = GuessBlueprint.render(guess)
    render json: blueprint
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error)
  end

  def strong_params
    params.permit(:category, :term)
  end
end
