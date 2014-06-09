class FakeClient
  attr_accessor :requests

  FIXTURES = {
    'sessions'          => { 'api_session_token' => {} },
    'projects'          => { 'projects' => [{}] },
    'projects/abcd1234' => { 'project' => {} },
    'orders'            => { 'orders' => [{}] },
    'orders/abcd1234' => { 'order' => {} },
    'panels'            => { 'panels' => [{}] },
    'panels/abcd1234' => { 'panel' => {} },
  }

  def initialize
    self.requests = []
  end

  def request method, endpoint, params={}
    requests << [method, endpoint, params]
    yield FIXTURES[endpoint]
  end

end
