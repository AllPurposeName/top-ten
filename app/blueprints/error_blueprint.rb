class ErrorBlueprint < Blueprinter::Base

  field :error_code
  field :external_message, name: :message
end


