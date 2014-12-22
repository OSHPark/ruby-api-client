module Oshpark
  class Token

    attr_accessor :expires_at

    def initialize json={}
      super
      @expires_at = Time.now + (@ttl || 0)
    end

    def self.attrs
      %w| token ttl user_id |
    end

    include Model

    def ttl
      expires_at - Time.now
    end

    def user
      User.from_json 'id' => user_id
    end

    def valid?
      ttl > 0
    end

  end
end
