class Array
  def extract_options!(*args)
    last.is_a?(Hash) ? pop : {}
  end
end