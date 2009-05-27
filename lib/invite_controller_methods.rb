module InviteControllerMethods
  # This makes sure that the before filter is added when included
  def self.included(base)
    base.before_filter :check_for_invite_or_user
  end
  
  # This makes sure that the current user either has an invite, or is logged in - or doesn't need either based on the request
  def check_for_invite_or_user
    redirect_to invites_path unless doesnt_need_an_invite || allowed_request?
  end
  
  # This returns true if the user doesn't need an invite (because they already have one, or are already logged in)
  def doesnt_need_an_invite
    has_invite? || logged_in?
  end
  
  # This returns true if the request is allowed (without an invite/login), false otherwise
  def allowed_request?
    # We'll allow access to the invite pages, and the login actions too
    allowed_paths.each do |uri|
      return true if request.request_uri.starts_with?(uri)
    end
    # Anything else, won't be allowed without a valid user login or invite
    false
  end
  
  # This returns all allowed paths
  def allowed_paths
    allowed = [invites_path, login_path]
    allowed << session_path if respond_to?(:session_path)
    allowed << sessions_path if respond_to?(:sessions_path)
    allowed
  end
  
  # This returns true if there is an invite in the session, false otherwise
  def has_invite?
    !current_invite.nil?
  end
  
  # This returns the invite that's in the session
  def current_invite
    find_invite(session[:invite]) unless session[:invite].nil?
  end
  
  # This finds the invite by its slug, nil if it cannot be found or isn't valid
  def find_invite(slug)
    # Find the invite by slug
    i = Invite.find(:first, :conditions => {:slug => slug})
    # If we found one, we'll make sure it either has no expiry, or has one in the future, otherwise lets ignore it
    i = nil unless i.nil? || i.expires_at.nil? || i.expires_at > Time.now
    # Return the invite
    i
  end
end