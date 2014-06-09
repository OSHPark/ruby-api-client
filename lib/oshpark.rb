require "oshpark/version"
require "oshpark/client"
require "oshpark/connection"
require "oshpark/model"
require "oshpark/dimensionable"
require "oshpark/project"
require "oshpark/order"
require "oshpark/panel"
require "oshpark/image"
require "oshpark/layer"
require "oshpark/token"

module Oshpark

  module_function

  def client *args
    Client.new *args
  end
end
