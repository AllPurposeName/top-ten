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
    blueprint = Rails.cache.fetch("answers?filters[category]=#{strong_params[:category]}&sort_on=#{sort_on}&sort_direction=#{sort_direction}", expires: 1.hour) do
      answers = Answer.in_category(filtered_category).reorder(sort_on => sort_direction)
      AnswerBlueprint.render(answers)
    end
    render json: blueprint
  end

  def filtered_category
    Category.find_by(name: strong_params[:category])
  end

  def sort_on
    if Answer.column_names.include?(strong_params[:sort_on])
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
    params.permit(:category, :sort_on, :sort_direction)
  end
end
