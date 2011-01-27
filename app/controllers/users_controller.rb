class UsersController < ApplicationController

  before_filter :login_required, :only => ['main', 'save', 'remove_password']

  def sign_in
    @login = params[:login]

    flash[:notice] = 'Notepad is password protected. Enter something'

    if request.get?
      if login_required(false)
        redirect_to '/' + params['login']
      end
    end

    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])

      if !user.nil?
        session[:id] = user.id
        redirect_to '/' + params[:login]
      else
        flash[:notice] = 'Bad password. Try again'
      end
    end
  end

  def sign_out
    session[:id] = nil
    redirect_to '/login/' + params[:login]
  end

  #def add_password
  #end

  def remove_password
    user = User.find_by_login(params[:login])
    user.password = '' if !user.nil?
    session[:id] = nil
    redirect_to '/' + params[:login]
  end

  def main
    login = params[:login]

    if login.nil?
      redirect_to '/' + User.random_login
      return
    end

    @user = User.find_by_login(login)

    # Creates new user
    if @user.nil?
      @user = User.new
      @user.login = login
      @user.password = ''
      @user.content = ''
      @user.save
    end
  end

  def save
    @user = User.find_by_login(params[:login])
    return if @user.nil?

    if !params[:content].nil?
      @user.content = params[:content]
      @user.save
    end

    render :nothing => true
  end
end

