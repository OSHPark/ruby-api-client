module Helper
  def cleanup
    Oshpark.client.authenticate ENV['USERNAME'], with_api_secret: ENV['API_SECRET']

    Oshpark.client.projects['projects'].each do |project|
      Oshpark.client.destroy_project project['id']
    end

    Oshpark.client.orders['orders'].each do |order|
      Oshpark.client.cancel_order order['id']
    end

  rescue
  ensure
    Oshpark.client.abandon
  end
end
