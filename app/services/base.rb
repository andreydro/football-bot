# frozen_string_literal: true

class Base
  include Helpers

  attr_reader :message, :client

  def initialize(client, message)
    @client = client
    @message = message
  end
end
