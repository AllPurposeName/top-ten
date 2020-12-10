class GuessBlueprint < Blueprinter::Base
  field :term
  field :correct


  association :results, blueprint: ResultBlueprint do |_guess, options|
    options[:results]
  end

  association :category, blueprint: CategoryBlueprint
end
