# Oshpark
##An electric ecosystem

[ ![Codeship Status for OSHPark/ruby-api-client](https://codeship.io/projects/a0abc8d0-d247-0131-3eb6-7653b9bc7be9/status?branch=master)](https://codeship.io/projects/23318)

[OSH Park](https://oshpark.com) is a community printed circuit board (PCB) order.
The Oshpark gem allows developers to easily access the Oshpark API. Developer resources can be found at [https://oshpark.com/developer](https://oshpark.com/developer)

## Installation

Add this line to your application's Gemfile:

    gem 'oshpark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oshpark

## Usage

Before you begin you need to have an [Oshpark account](http://oshpark.com/users/sign_up) and then request access to the Oshpark API. Do this by contacting ????

This gem provides two interfaces to the OShpark API.

### Low level API

For use when you have an ORM, framework or pre-exsiting classes that you want to load the Oshpark data into.

The API consists of a number of methods that map to the methods exposed by the Oshpark REST API. These methods take Ruby hashes representing the request data and return hashes of the API responses. Refer to [https://oshpark.com/developer/resources](https://oshpark.com/developer/resources) for details.

First create an Oshpark::client object and authenticate;

    client = Oshpark::client
    client.authenticate 'jane@resistor.io', {with_password: 'secret'}

Then you can can use this object to interact with Oshpark;

    file = File.open('my_pcb.zip', 'r')
    upload = client.create_upload file
    ...
    my_projects = client.projects
    ...
    project = client.project 'id'
    client.update_project project["id"], {"name" => "my awesome project"}
    ...
    new_order = client.create_order
    ...

All low level methods will call to Oshpark's servers. Refer to the documentation for more detailed information on each of the available methods.

### High Level API

This is more suited to when you are writing a script or application and you want to use Ruby objects to represent the Oshpark data. It uses the Low Level API underneath but wraps the return data in nice Ruby objects.

Again begin by creating an Oshpark::client and authenticating;

    client = Oshpark::client
    client.authenticate 'jane@resistor.io', {with_password: 'secret'}

    file = File.open('my_pcb.zip', 'r')
    upload = Oshpark::Upload.create file
    ...
    my_projects = Oshpark::Project.all
    ...
    project = Oshpark::Project.find 'id'
    project.name = "my awesome project"
    project.save!
    ...
    new_order = Oshpark::Order.create
    ...


## Contributing

1. Fork it ( https://github.com/[my-github-username]/oshpark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


