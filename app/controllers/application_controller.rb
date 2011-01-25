class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required(redirect_after = true)
    user = User.find_by_login(params[:login])

    return true if user.nil?
    return true if !user.has_password
    return true if session[:id] == user.id

    redirect_to '/login/' + params[:login] if redirect_after
    return false
  end
end

