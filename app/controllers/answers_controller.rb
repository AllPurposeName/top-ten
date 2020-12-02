class AnswersController < ApplicationController
  def show
    ensure_request_decoded
    Rails.cache.fetch("answers/#{params[:id]}", expires: 1.hour) do
      answer    = Answer.find_by(id: params[:id])
      blueprint = AnswerBlueprint.render(answer)
      render json: blueprint
    end
  end

  def index
    ensure_request_decoded
    blueprint = Rails.cache.fetch("answers?filters[category]=#{strong_params[:category]}", expires: 1.hour) do
      answers = Answer.in_category(filtered_category).order(:category_id).order(:ranking)
      AnswerBlueprint.render(answers)
    end
    render json: blueprint
  end

  def filtered_category
    Category.find_by(name: strong_params[:category])
  end

  def strong_params
    params.permit(:category)
  end
end
