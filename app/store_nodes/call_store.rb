class CallStore < RatCatcherStore

  def initialize(new_sexp)
    super(new_sexp)

    @children << RatCatcherStore.from_sexp(new_sexp[1])
    
    if new_sexp[3].size > 1
      new_sexp[3][1..-1].each do |arg|
        @children << RatCatcherStore.from_sexp(arg)
      end
    end

    @text= (new_sexp[2] == :-@)? '-': new_sexp[2].to_s
  end


  def method_selector
    (@children.size == 1  &&  text == '-') ? :-@ :  text.to_sym
  end

  def arguments
    s(:arglist, *sexplist_from_children[1..-1] )
  end

  def receiver
    @children[0].sexp
  end

  def sexp
    s(:call, receiver, method_selector, arguments)
  end
end
