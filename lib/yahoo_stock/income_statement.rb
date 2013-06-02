module YahooStock

  # income = YahooStock::IncomeStatement.new(stock_symbol: 'yhoo')
  # income.results(:to_hash).output
  class IncomeStatement < Base
    class QuoteException < RuntimeError; end

    def initialize(options)
      if options.nil? || !options.is_a?(Hash)
        raise QuoteException, "You must provide a hash of stock symbols to fetch data"
      end
      if options[:stock_symbol].nil? || options[:stock_symbol].empty?
        raise QuoteException, "You must provide at least one stock symbol to fetch data"
      end
      @interface = YahooStock::Interface::IncomeStatement.new(options)
    end

    def results(type=nil, &block)
      super { @interface.results }
    end
  end
end
