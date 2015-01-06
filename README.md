# OSH Park
##An electric ecosystem

[ ![Codeship Status for OSHPark/ruby-api-client](https://codeship.io/projects/a0abc8d0-d247-0131-3eb6-7653b9bc7be9/status?branch=master)](https://codeship.io/projects/23318)

[OSH Park](https://oshpark.com) is a community printed circuit board (PCB) order.
The OSH Park gem allows developers to easily access the OSH Park API. Developer resources can be found at [https://oshpark.com/developer](https://oshpark.com/developer)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oshpark'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install oshpark
```

## Usage

Before you begin you need to have an [OSH Park account](http://oshpark.com/users/sign_up) and then request access to the OSH Park API. Do this by contacting [OSH Park support](mailto:support@oshpark.com)

This gem provides two interfaces to the OSH Park API.

### Low level API

For use when you have an ORM, framework or pre-exsiting classes that you want to load the OSH Park data into.

The API consists of a number of methods that map to the methods exposed by the OSH Park REST API. These methods take Ruby hashes representing the request data and return hashes of the API responses. Refer to [https://oshpark.com/developer/resources](https://oshpark.com/developer/resources) for details.

First create an `Oshpark::client` object and authenticate;

```ruby
client = Oshpark::client
client.authenticate 'jane@resistor.io', with_password: 'secret'
```

Then you can can use this object to interact with OSH Park;

```ruby
file = File.open('my_pcb.zip', 'r')
upload = client.create_upload file
# ...
my_projects = client.projects
# ...
project = client.project 'id'
client.update_project project["id"], {"name" => "my awesome project"}
# ...
new_order = client.create_order
# ...
```

All low level methods will call to OSH Park's servers. Refer to the [source documentation](http://www.rubydoc.info/github/OSHPark/ruby-api-client/master) for more detailed information on each of the available methods.

### High Level API

This is more suited to when you are writing a script or application and you want to use Ruby objects to represent the OSH Park data. It uses the Low Level API underneath but wraps the return data in nice Ruby objects.

#### Authenticate

```ruby
client = Oshpark::client
client.authenticate 'jane@resistor.io', with_password: 'secret'
```

or with your API secret if you have one:

```ruby
client = Oshpark::client
client.authenticate 'jane@resistor.io', with_api_secret: 'secret'
```

##### Creating Your Project

Next you need to get your project into OSH Park.  This is done by either
uploading a file or importing a file from a URL.

###### Upload

To upload a file directly to the API you create an `Oshpark::Upload` object by
passing in an `IO` object:

```ruby
file   = File.open 'my_pcb.zip'
upload = Oshpark::Upload.create file
file.close
```

You now need to wait for processing of the file to complete:

```ruby
until upload.finished?
  sleep 1
  upload.reload!
end
```

Now you can access your project via the upload's `project` method:

```ruby
project = upload.project
```

###### Import

Importing from a remote URL is almost exactly the same as uploading, except
that you create an instance of the `Oshpark::Import` object, and monitor it
in much the same was as upload:

```ruby
import = Oshpark::Upload.create 'https://example.com/my_pcb.zip'
```

You now need to wait for processing of the file to complete:

```ruby
until import.finished?
  sleep 1
  import.reload!
end
```

Now you can access your project via the import's `project` method:

```ruby
project = import.project
```

##### Verifying your project

Next you need to verify that your board has been processed as expected.
Start by verifying that the `top_image` and `bottom_image` match your
expectations and verify that all the `layers` that you expect are present
with their image files.

Once you are certain that we have processed your board correctly, then you
can approve it for ordering:

```ruby
project.approve
```

##### Ordering your project

There are a few steps to go through before you can order your board (or boards)
via the API:

###### Create a new order

The first step is to create a new, empty order into which you will add your items:

```ruby
order = Oshpark::Order.create
```

###### Add your project(s) to your order

Next you need to add your project(s) to your order, specifying their quantity.
Remember that for prototype services quantities must be in multiples of three.

```ruby
order.add_item project, 3
```

###### Create an address

Create an address object with your delivery details:

```ruby
address = Oshpark::Address.new \
  name:               'Jane Doe',
  company_name:       'Resistor Ltd',
  address_line_1:     'Level One, 83-85 Victoria Road',
  address_line_2:     'Devonport',
  city:               'Auckland',
  zip_or_postal_code: '0624',
  country:            'nz'
```

###### Set your order address

Once you have generated your address, you can set it on the order:

```ruby
order.set_address address
```

###### Get and set the shipping rates

As our shipping providers generate individual pricing for each destination
address you need to ask the API to retrieve all the available rates for your
address.  The available rates will always include the USPS free shipping
options.

```ruby
rates = address.available_shipping_rates
```

Set your order to one of the provided shipping rates:

```ruby
order.set_shipping_rate rates.first
```

###### Checkout your order

Next you should be able to checkout your order:

```ruby
order.checkout
```

If you are an invoiced customer then your order will immediately be placed in
the queue ready for panelization, otherwise you will get an email asking for
payment before the order can continue.  We can't accept credit card payments
via the API at this time.

If you are not, but would like to be an invoiced customer then contact [OSH Park support](mailto:support@oshpark.com).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/oshpark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


