class PromptsController < ApplicationController
  PER_PAGE = 15

  allow_unauthenticated_access

  def index
    @categories = Category.ordered.left_joins(:prompts)
                          .select("categories.*, COUNT(prompts.id) AS prompts_count")
                          .group("categories.id")
    @category = Category.find_by!(slug: params[:category]) if params[:category].present?
    @query = params[:q].to_s.strip
    @sort = Prompt::SORTS.key?(params[:sort]) ? params[:sort] : "newest"
    @page = [ params[:page].to_i, 1 ].max

    scope = Prompt.in_category(@category).search(@query)
    @total = scope.count
    @prompts = scope.with_image.includes(:category).sorted_by(@sort)
                    .offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    @next_page = @page + 1 if @total > @page * PER_PAGE

    # Live search / filters / "load more" are fetched by vanilla JS and only
    # need the results fragment, not the whole page.
    if request.xhr?
      render partial: "prompts/results", locals: { prompts: @prompts, total: @total, next_page: @next_page }
    end
  end

  def show
    @prompt = Prompt.with_image.includes(:category).find_by!(slug: params[:id])
    @related = @prompt.related
  end
end
