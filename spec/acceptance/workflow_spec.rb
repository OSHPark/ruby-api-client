require 'spec_helper'

# Apologies for writing these as just a huge long example, but I couldn't
# think of a better way of doing it without installing cucumber or turnip
# which I don't think are a good match for testing Ruby code directly.

describe 'API Workflow' do
  extend SwitchCassette
  include Helper

  before { cleanup }
  after  { cleanup }

  specify "Ordering a board" do
    Oshpark.client.authenticate ENV['USERNAME'], with_api_secret: ENV['API_SECRET']
    expect(Oshpark.client.token).to be_authentic

    file = File.open(File.expand_path('../../fixtures/2-Layer.brd', __FILE__))
    upload = Oshpark::Upload.create file
    file.close

    expect(upload).to be_processing

    until upload.finished?
      sleep 1 if ENV.has_key? 'CI'
      upload.reload!
    end
    expect(upload).to be_success

    project = upload.project
    expect(project).to be_new

    expect(project.top_image).to be_a Oshpark::Image
    expect(project.bottom_image).to be_a Oshpark::Image
    expect(project.layers.size).to eq 7
    expect(project.layers.all? { |l| l.class == Oshpark::Layer }).to eq true

    project.approve

    expect(project).to be_approved

    order = Oshpark::Order.create
    expect(order.order_items).to be_empty
    order.add_item project, 3
    expect(order.order_items).to be_one

    address = Oshpark::Address.new \
      name:               'James Harton',
      company_name:       'Resistor Ltd',
      address_line_1:     'Level One, 83-85 Victoria Road',
      address_line_2:     'Devonport',
      city:               'Auckland',
      zip_or_postal_code: '0624',
      country:            'nz'

    expect(order.address).not_to be
    order.set_address address
    expect(order.address).to be

    rates = address.available_shipping_rates
    expect(rates).not_to be_empty

    expect(order.shipping_rate).not_to be
    order.set_shipping_rate rates.first
    expect(order.shipping_rate).to be

    order.checkout
    expect(order).to be_received
  end
end
