# frozen_string_literal: true

class CancelMatchesController < ApplicationController
  def show
    match.cancel! if match.present?
    redirect_to admin_matches_path
  end

  private

  def match
    @match ||= Match.find_by(id: params[:id])
  end
end
