require "oshpark/version"
require "oshpark/ext"
require "oshpark/client"
require "oshpark/connection"
require "oshpark/model"
require "oshpark/dimensionable"
require "oshpark/order_option"
require "oshpark/project"
require "oshpark/order"
require "oshpark/panel"
require "oshpark/image"
require "oshpark/layer"
require "oshpark/user"
require "oshpark/import"
require "oshpark/upload"
require "oshpark/token"
require "oshpark/address"
require "oshpark/shipping_rate"
require "oshpark/order_item"
require "oshpark/order_item_option_selection"

module Oshpark

  module_function

  def client *args
    if args.size > 0
      @client = Client.new *args
    else
      @client ||= Client.new
    end
  end
end
