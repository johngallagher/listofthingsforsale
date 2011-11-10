# encoding: UTF-8
module Currency
  GBP = "GBP"
  USD = "USD"
  
  Supported = [Currency::USD, Currency::GBP] # in order of preference - default one first
  Symbol = {
    Currency::GBP => '£',
    Currency::USD => '$'
  }
  EscapedSymbol = {
    Currency::GBP => '£',
    Currency::USD => '\$'
  }
end