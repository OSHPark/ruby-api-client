module Oshpark
  class Token

    attr_accessor :expires_at

    def ttl
      expires_at - Time.now
    end

    def user
      User.from_json 'id' => user_id
    end

    def ttl= i
      sel.expires_at = Time.now + i
    end

    def self.attrs
      %w| token ttl user_id |
    end

    include Model
  end
end
