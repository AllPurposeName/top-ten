class GuessBlueprint < Blueprinter::Base
  field :term
  field :correct


  association :results, blueprint: ResultBlueprint, if: -> (_res, _guess, options) { options[:results] } do |_guess, options|
    options[:results]
  end

  association :category, blueprint: CategoryBlueprint
end
