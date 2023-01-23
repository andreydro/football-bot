# frozen_string_literal: true

class Base
  include Helpers

  attr_reader :message

  def initialize(message)
    @message = message
  end
end
