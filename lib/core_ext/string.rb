class String
  def classify
    split('_').collect!{ |w| w.capitalize }.join
  end

  def constantize
    split("::").inject(Module) {|acc, val| acc.const_get(val)}
  end
end


