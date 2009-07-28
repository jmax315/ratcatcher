class LasgnStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)
    @text= "#{new_sexp[1].to_s} = #{new_sexp[2][1]}"
  end

  #TODO sexp
end
