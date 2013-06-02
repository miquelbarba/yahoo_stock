$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'date'
require 'csv'
require 'yahoo_stock/base.rb'
require 'yahoo_stock/interface.rb'
require 'yahoo_stock/history.rb'
require 'yahoo_stock/scrip_symbol.rb'
require 'yahoo_stock/quote.rb'
require 'yahoo_stock/balance_sheet.rb'
require 'yahoo_stock/income_statement.rb'
require 'yahoo_stock/interface/quote.rb'
require 'yahoo_stock/interface/history.rb'
require 'yahoo_stock/interface/scrip_symbol.rb'
require 'yahoo_stock/interface/balance_sheet.rb'
require 'yahoo_stock/interface/income_statement.rb'
require 'yahoo_stock/result.rb'
require 'yahoo_stock/result/array_format.rb'
require 'yahoo_stock/result/hash_format.rb'
require 'yahoo_stock/result/xml_format.rb'

module YahooStock
  VERSION = '1.0.3'
end