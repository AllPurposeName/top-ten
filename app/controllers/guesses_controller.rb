class GuessesController < ApplicationController
  def index
    ensure_request_decoded
    blueprint = Rails.cache.fetch("guesses?filters[category]=#{strong_params[:category]}&sort_on=#{sort_on}&sort_direction=#{sort_direction}", expires: 1.hour) do
      guesses   = Guess.in_category(filtered_category).reorder(sort_on => sort_direction)
      GuessBlueprint.render(guesses)
    end
    render json: blueprint, status: 200
  end

  def create
    ensure_request_decoded
    guess     = GuessFactory.guess!(
      category: strong_params[:category],
      term: strong_params[:term],
      user: current_user
    )
    blueprint = GuessWrapperBlueprint.render(
      guess[:wrapper],
      guess: guess[:guess],
      results: guess[:results],
      victory: guess[:victory]
    )
    render json: blueprint, status: 201
  rescue ErrorService::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def filtered_category
    Category.find_by(name: strong_params[:category])
  end

  def sort_on
    if Guess.column_names.include?(strong_params[:sort_on])
      strong_params[:sort_on]
    else
      'created_at'
    end
  end

  def sort_direction
    if ['asc', 'desc'].include?(strong_params[:sort_direction])
      strong_params[:sort_direction]
    else
      'desc'
    end
  end

  def strong_params
    params.permit(:category, :term, :sort_on, :sort_direction)
  end
end
