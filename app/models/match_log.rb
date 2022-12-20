# frozen_string_literal: true

# Model to save logs for matches
class MatchLog < ApplicationRecord
  belongs_to :match

  def create_log(content, match_id)
    content_wrapper = "#{Time.current}: #{content}"
    assign_attributes(match_id: match_id, content: content_wrapper)
    save!
  end
end
