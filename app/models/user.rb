# frozen_string_literal: true

class User < ApplicationRecord
  has_many :match_forms, dependent: :destroy
  has_many :matches, dependent: :destroy
end
