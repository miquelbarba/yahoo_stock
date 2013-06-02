require 'nokogiri'

module YahooStock
  class Interface::IncomeStatement < Interface

    class QuoteError < RuntimeError ; end

    attr_reader :stock_symbols

    def initialize(stock_params_hash)
      @stock_symbol         = stock_params_hash[:stock_symbol]
      @base_url             = BASE_URLS[:income_statement]
      add_observer(self)
    end

    # Generate full url to be sent to yahoo
    def uri
      @uri_parameters = {:s => @stock_symbol, :annual => true}
      super
    end

    # Read the result using get method in super class
    def get
      uri
      super()
    end

    def results
      doc = Nokogiri::HTML(get)
      table = doc.xpath('//*[@id="yfncsumtab"]/tr[2]/td/table[2]/tr/td/table/tr').
                  map {|tr| tr.children.map {|td| td.content.gsub(/\s+/, "").gsub(/[[:space:]]/, '')}}.compact.
                  each {|ary| ary.delete('')}.
                  select {|ary| ary.uniq.length > 1}.
                  map {|ary| [underscore(ary.first).to_sym] + ary[1..-1]}

      data = Hash.new
      dates = table.first[1..-1].map {|s| Date.parse(s)}
      table[1..-1].each do |ary|
        #items = Hash.new
        #dates.each_with_index {|date, i| items[date] = ary[i + 1]}
        numbers = ary[1..-1].map do |s|
          if s == '-'
            nil
          else
            s.gsub!(',', '')
            num = s[0] == '(' ? "-#{s[1..-2]}" : s
            num.to_i * 1000
          end
        end

        items = dates.zip(numbers)
        #items = dates.each_with_index.map {|date, i| [date, ary[i + 1]]}
        data[ary.first] = items
      end

      data
    end

    private

    # copy from rails
    def underscore(s)
      s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
