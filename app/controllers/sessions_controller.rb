class SessionsController < ApplicationController
  def new
    @uname = params[:user_name]
  end

  def create
    user = User.authenticate(params[:session][:user_name], params[:session][:password])

    if user.nil?
      redirect_to '/login/' + params[:session][:user_name]
    else
      sign_in user
      redirect_to '/' + params[:session][:user_name]
    end
  end

  def destroy
    sign_out
    redirect_to '/login/' + params[:user_name]
  end
end

