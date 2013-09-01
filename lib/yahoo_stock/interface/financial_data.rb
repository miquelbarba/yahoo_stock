require 'nokogiri'
require 'net/http'
require 'uri'


module YahooStock
  class Interface::FinancialData < Interface
    def initialize(stock_params_hash)
      @stock_symbol         = stock_params_hash[:stock_symbol]
      @base_url             = BASE_URLS[:income_statement]
      @annual               = stock_params_hash[:type] == 'annual'
      add_observer(self)
    end

    # Generate full url to be sent to yahoo
    def uri
      @uri_parameters = {:s => @stock_symbol}
      @uri_parameters[:annual] = @annual if @annual
      super
    end

    # Read the result using get method in super class
    def get
      uri
      super()
    end

    def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      url = URI.parse(uri_str)
      req = Net::HTTP::Get.new("#{url.path}?#{url.query}")
      response = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          response.error!
      end
    end

    def results
      doc = Nokogiri::HTML(fetch(uri))
      table = doc.xpath('//*[@id="yfncsumtab"]/tr[2]/td/table[2]/tr/td/table/tr').
                  map {|tr| tr.children.map {|td| td.content.gsub(/\s+/, "").gsub(/[[:space:]]/, '')}}.compact.
                  each {|ary| ary.delete('')}.
                  select {|ary| ary.uniq.length > 1}.
                  map {|ary| [underscore(ary.first).to_sym] + ary[1..-1]}

      data = Hash.new
      if table.any?
        dates = table.first[1..-1].map {|s| Date.parse(s)}
        table[1..-1].each do |ary|
          numbers = ary[1..-1].map do |s|
            if s == '-'
              nil
            else
              s.gsub!(',', '')
              num = s[0] == '(' ? "-#{s[1..-2]}" : s
              num.to_i * 1000
            end
          end

          data[ary.first] = dates.zip(numbers)
        end

        type = @annual ? 'annual' : 'quarterly'
        data[:type] = dates.map { |date| [date, type] }
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
