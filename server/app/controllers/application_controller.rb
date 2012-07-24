class ApplicationController < ActionController::Base
  # protect_from_forger :expect => []
  #before_filter :protect_from , :only => [:create]
  
  def protect_from
    if params[:authenticity_token] == "zKtbh5mbSBcs/CtRX EWlPEhBGOaknL5OMcz 5jK7wM="
      return true
    else
      render status: 404, nothing: true
    end
  end

  def authenticate_user!
    unless current_user
      render :text => "You need to sign in or sign up before", :status => 401 and return
    end
  end
end
