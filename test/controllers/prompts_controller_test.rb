require "test_helper"

class PromptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prompt = prompts(:one)
    @category = categories(:portraits)
  end

  test "should get index" do
    get prompts_url
    assert_response :success
    assert_select "h1", text: /Prompts that paint/
    assert_select ".card", minimum: 1
    assert_select "[data-search-form]"
    assert_select "[data-category-chips]"
  end

  test "should get index with category filter" do
    get category_url(@category.slug)
    assert_response :success
    assert_select "h1", text: @category.name
    assert_select ".chip.is-active", text: /#{@category.name}/
  end

  test "should get index with search query" do
    get prompts_url, params: { q: "Golden" }
    assert_response :success
    assert_select ".card__title", text: /Golden Hour/
  end

  test "should return xhr partial for live search" do
    get prompts_url, headers: { "X-Requested-With" => "XMLHttpRequest" }, params: { q: "Golden" }
    assert_response :success
    # Should render the results partial, not the entire HTML layout
    assert_select "header.site-header", count: 0
    assert_select ".grid", count: 1
    assert_select ".card__title", text: /Golden Hour/
  end

  test "should get show" do
    get prompt_url(@prompt)
    assert_response :success
    assert_select "h1.detail__title", text: @prompt.title
    assert_select ".prompt-box__text", text: @prompt.body
    assert_select "[data-copy]", minimum: 1
  end

  test "guest sees premium prompt locked" do
    premium = prompts(:premium)
    get prompt_url(premium)
    assert_response :success
    assert_select ".locked"
    assert_not_includes response.body, premium.body
  end

  test "member sees premium prompt text" do
    sign_in_as users(:member)
    premium = prompts(:premium)
    get prompt_url(premium)
    assert_response :success
    assert_select ".prompt-box__text", text: premium.body
  end

  test "guest index does not leak premium prompt body" do
    get prompts_url
    assert_response :success
    assert_not_includes response.body, prompts(:premium).body
  end
end
