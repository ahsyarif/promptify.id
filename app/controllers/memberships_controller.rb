class MembershipsController < ApplicationController
  def show
    @premium_count = Prompt.where(premium: true).count
  end
end
