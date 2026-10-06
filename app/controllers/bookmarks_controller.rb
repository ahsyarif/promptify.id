class BookmarksController < ApplicationController
  before_action :set_prompt, only: %i[ create destroy ]

  def index
    @prompts = Current.user.bookmarked_prompts
                      .with_image.includes(:category)
                      .order("bookmarks.created_at DESC")
  end

  def create
    Current.user.bookmarks.find_or_create_by!(prompt: @prompt)
    respond(bookmarked: true)
  rescue ActiveRecord::RecordNotUnique
    respond(bookmarked: true)
  end

  def destroy
    Current.user.bookmarks.find_by(prompt: @prompt)&.destroy
    respond(bookmarked: false)
  end

  private
    def set_prompt
      @prompt = Prompt.find_by!(slug: params[:prompt_id])
    end

    def respond(bookmarked:)
      respond_to do |format|
        format.json do
          render json: {
            bookmarked: bookmarked,
            prompt_id: @prompt.id,
            bookmarks_count: @prompt.reload.bookmarks_count,
            saved_total: Current.user.bookmarks.count
          }
        end
        format.html { redirect_back_or_to prompt_path(@prompt) }
      end
    end
end
