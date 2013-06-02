module YahooStock

  # balance = YahooStock::BalanceSheet.new(stock_symbol: 'yhoo')
  # balance.results(:to_hash)
  class BalanceSheet < Base
    class QuoteException < RuntimeError; end

    def initialize(options)
      if options.nil? || !options.is_a?(Hash)
        raise QuoteException, "You must provide a hash of stock symbols to fetch data"
      end
      if options[:stock_symbol].nil? || options[:stock_symbol].empty?
        raise QuoteException, "You must provide at least one stock symbol to fetch data"
      end
      @interface = YahooStock::Interface::BalanceSheet.new(options)
    end

    def results(type=nil, &block)
      super { @interface.results }
    end
  end
end
