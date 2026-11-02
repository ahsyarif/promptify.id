class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :unlocked?

  private
    # Resumes the session (if any) so public pages still know who is signed in.
    def current_user
      resume_session
      Current.user
    end

    # Premium prompts are readable by members; everyone else sees the teaser only.
    def unlocked?(prompt) = !prompt.premium? || !!current_user&.member?
end
