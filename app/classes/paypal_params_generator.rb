require 'status'

class PaypalParamsGenerator
  def initialize(args)
    raise "Order cannot be nil" if args[:order].nil?
    @order = args[:order]
    @payment_status = args[:payment_status].nil? ? @order.status : args[:payment_status]
    @currency = args[:currency].nil? ? "USD" : args[:currency]
  end
  
  def generate_params
    setup_params
    add_email_params
    add_line_items_params
    add_payment_status
    add_currency
    return @params
  end
  
private
  def setup_params
    @params = {  
      "protection_eligibility"=>"Eligible",
       "address_status"=>"confirmed",
       "tax"=>"0.00",
       "payer_id"=>"MDKEM85G3LMLA",
       "address_street"=>"1 Main Terrace",
       "payment_date"=>"14:17:24 Sep 28, 2011 PDT",
       "charset"=>"windows-1252",
       "address_zip"=>"W12 4LQ",
       "mc_shipping"=>"0.00",
       "mc_handling"=>"0.00",
       "first_name"=>"Test",
       "mc_fee"=>"0.71",
       "address_country_code"=>"GB",
       "address_name"=>"Test User",
       "notify_version"=>"3.2",
       "custom"=>"",
       "payer_status"=>"verified",
       "address_country"=>"United Kingdom",
       "mc_handling1"=>"0.00",
       "address_city"=>"Wolverhampton",
       "verify_sign"=>"ACTQ-IEZ9gMsbO0Pw-mucb3t592GAazwT2TyT4UVXsV9nnRONUdx7DGt",
       "mc_shipping1"=>"0.00",
       "payment_type"=>"instant",
       "last_name"=>"User",
       "address_state"=>"West Midlands",
       "payment_fee"=>"",
       "receiver_id"=>"5EC9ZN6KQH47N",
       "txn_type"=>"cart",
       "residence_country"=>"GB",
       "test_ipn"=>"1",
       "transaction_subject"=>"Shopping Cart",
       "ipn_track_id"=>"LlEfeRjfHawhnM1zyCcqrA",

       "num_cart_items"=>"#{@order.line_items.count}",


       #transaction id
       "txn_id"=>"1E232785L98112148",

       #total
       "mc_gross"=>"#{@order.total_price}",
       "payment_gross"=>"#{@order.total_price}",

       "session_id"=>"#{@order.session_id}" 
    }
  end
  
  def add_email_params
    if @order.shop and @order.shop.user
      emails = { 
        "business"=>"#{@order.shop.user.email}",
        "receiver_email"=>"#{@order.shop.user.email}",
        "payer_email"=>"" 
        }
    else
      emails = { 
        "business"=>"",
        "receiver_email"=>"",
        "payer_email"=>"" 
        }
    end
    @params.merge!(emails)
  end
  
  def add_line_items_params
    @order.line_items.each_index do |li_index|
      li_index_inc = li_index + 1
      this_item = {
        "option_name1_#{li_index_inc}"=>"shopid",
        "option_selection1_#{li_index_inc}"=>"#{@order.shop_id}",

        "option_name2_#{li_index_inc}"=>"itemid",
        "option_selection2_#{li_index_inc}"=>"#{@order.line_items[li_index].item.id}",
        "quantity#{li_index_inc}"=>"1",
        "mc_gross_#{li_index_inc}"=>"#{@order.line_items[li_index].unit_price}",
        "item_name#{li_index_inc}"=>"#{@order.line_items[li_index].name}",
        "item_number#{li_index_inc}"=>"#{li_index_inc}",
      }
      @params.merge!(this_item)
    end
  end
  
  def add_payment_status
    @params.merge!("payment_status"=>"#{@payment_status}")
  end
  
  def add_currency
    @params.merge!("mc_currency"=>"#{@currency}")
  end
end