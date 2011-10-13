require 'ripper'

class Sexp
end

class RatCatcherRipper < Ripper
  def initialize(*args)
    super(*args)
  end

  PARSER_EVENTS.each do |event|
    eval <<-End
      def on_#{event}(*args)
        args.unshift :#{event}
        args
      end
      End
  end

  SCANNER_EVENTS.each do |event|
      eval <<-End
      def on_#{event}(tok)
        tok
      end
      End
  end

  def process
    parse
  end
end
