class ErrorService
  BasicError = Class.new(StandardError)

  def self.build(name:, base:, message:, code:, http_status_code: 400)
    const_set(
      name,
      Class.new(const_get_or_set(base)) do
        define_method(:external_message) { message }
        define_method(:error_code)       { code }
        define_method(:http_status_code) { http_status_code }
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

