require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @prompt = prompts(:two) # prompt not yet bookmarked by user one
    @bookmarked_prompt = prompts(:one) # already bookmarked by user one
  end

  test "guest is redirected to sign in when saving via html" do
    post prompt_bookmark_url(@prompt)
    assert_redirected_to new_session_url
  end

  test "guest receives 401 json when saving via json" do
    post prompt_bookmark_url(@prompt), as: :json
    assert_response :unauthorized
    json = response.parsed_body
    assert_equal "Sign in required", json["error"]
    assert_equal new_session_path, json["login_url"]
  end

  test "authenticated user can bookmark a prompt via json" do
    sign_in_as(@user)
    assert_difference -> { @prompt.reload.bookmarks_count }, 1 do
      post prompt_bookmark_url(@prompt), as: :json
      assert_response :success
    end

    json = response.parsed_body
    assert_equal true, json["bookmarked"]
    assert_equal @prompt.id, json["prompt_id"]
    assert_equal 1, json["bookmarks_count"]
  end

  test "authenticated user can remove a bookmark via json" do
    sign_in_as(@user)
    assert_difference -> { @bookmarked_prompt.reload.bookmarks_count }, -1 do
      delete prompt_bookmark_url(@bookmarked_prompt), as: :json
      assert_response :success
    end

    json = response.parsed_body
    assert_equal false, json["bookmarked"]
  end

  test "authenticated user can view saved prompts" do
    sign_in_as(@user)
    get bookmarks_url
    assert_response :success
    assert_select "h1", text: /Saved prompts/
    assert_select ".card", minimum: 1
  end

  test "guest is redirected to sign in when accessing saved prompts" do
    get bookmarks_url
    assert_redirected_to new_session_url
  end
end
