require_relative 'financial_data'

module YahooStock
  class Interface::BalanceSheet < Interface::FinancialData

    def initialize(stock_params_hash)
      super
      @base_url = BASE_URLS[:balance_sheet]
    end
  end
end