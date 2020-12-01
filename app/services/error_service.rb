class ErrorService
  BasicError = Class.new(StandardError)

  def self.build(name:, base:, message:, code:)
    const_set(
      name,
      Class.new(const_get_or_set(base)) do
        define_method(:external_message) { message }
        define_method(:error_code)       { code }
      end
    )
  end

  def self.const_get_or_set(base_error_name = StandardError)
    if const_defined?(base_error_name)
      const_get(base_error_name)
    else
      const_set(base_error_name, BasicError)
    end
  end
end

