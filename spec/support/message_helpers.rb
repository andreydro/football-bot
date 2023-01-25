# frozen_string_literal: true

module MessageHelpers
  class From
    attr_reader :id, :username, :first_name, :last_name

    def initialize(id, username, first_name, last_name)
      @id = id
      @username = username
      @last_name = last_name
      @first_name = first_name
    end
  end

  class Message
    attr_reader :data

    def initialize(id, username, first_name, last_name, data = nil)
      @id = id
      @username = username
      @last_name = last_name
      @first_name = first_name
      @data = data
    end

    def from
      From.new(@id, @username, @first_name, @last_name)
    end
  end
end
