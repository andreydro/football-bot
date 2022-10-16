# frozen_string_literal: true

class User < ApplicationRecord
  has_many :match_forms
  has_many :matches
end
