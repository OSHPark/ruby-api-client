class FakeClient
  attr_accessor :requests

  FIXTURES = {
    'sessions'                  => { 'api_session_token' => {} },
    'projects'                  => { 'projects' => [{}] },
    'projects/abcd1234'         => { 'project' => {} },
    'projects/abcd1234/approve' => { 'project' => {} },
    'orders'                    => { 'orders' => [{}] },
    'orders/abcd1234'           => { 'order' => {} },
    'panels'                    => { 'panels' => [{}] },
    'panels/abcd1234'           => { 'panel' => {} },
  }

  def initialize foo
    self.requests = []
  end

  def request method, endpoint, params={}, token
    requests << [method, endpoint, params]
    FIXTURES[endpoint]
  end

end
