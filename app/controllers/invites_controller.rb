class InvitesController < ApplicationController
  unloadable
  
  skip_before_filter :login_required
  
  def index
    # Redirect if we don't need an invite as we don't need the user to see this page
    redirect_to "/" and return if doesnt_need_an_invite
  end
  
  def show
    # Redirect if we don't need an invite as we don't need the user to see this page
    redirect_to "/" and return if doesnt_need_an_invite
    # Otherwise, we find the invite, and set it in the session if it was valid
    @invite = find_invite(params[:id])
    session[:invite] = @invite.slug unless @invite.nil?
  end
  
  def create
    # We'll redirect back to the main page if no code, or an empty code was supplied
    if params["invite"].blank? || params["invite"]["code"].blank?
      redirect_to invites_path
    else
      # Otherwise we redirect to the show action with the specified code
      redirect_to invite_path(params["invite"]["code"])
    end
  end
end