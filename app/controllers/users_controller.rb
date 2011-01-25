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
      @user = User.new(:login => login, :content => '', :password => '', :has_password => false)
      @user.save
    end
  end

  def save
    @user = User.find_by_login(params[:login])
    @user.update_attributes(params[:user])

    passwd = params[:user][:password]
    @user.password = passwd if !passwd.nil? and !passwd.empty?

    @user.save

    redirect_to '/' + params[:login]
  end
end

