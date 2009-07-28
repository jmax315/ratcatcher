class MasgnStore < RatCatcherStore
  def initialize(new_sexp)
    super(new_sexp)
    vars = new_sexp[1][1..-1].map {|v| v[1].to_s}.join(',')
    # TODO: Refactor this method...
    
    # Create children here....
    
    # Use them to create the @text value...
    if new_sexp[2][0] == :to_ary
      vals = new_sexp[2][1][1..-1].map {|v| v[1].to_s}.join(',')      
      @text= "#{vars} = [#{vals}]"
    else
      vals = new_sexp[2][1..-1].map {|v| v[1].to_s}.join(',')
      @text= "#{vars} = #{vals}"
    end
  end
end
