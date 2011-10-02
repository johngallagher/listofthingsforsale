class SimpleCartManager < ApplicationController
  def clear_cart
    # cookies.delete("sc_simpleCart_1")
    render :js => "document.cookie = \"sc_simpleCart_1=; path=/\";"
  end
end