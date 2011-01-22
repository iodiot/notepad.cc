class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    #@user = User.find(params[:id])

    uname = params[:user_name]
    uname = '' if uname == nil

    # Redirects to unique user-name
    if uname == ''
      consonant = 'qwrtpsdfghjklzxcvbnm'.split('').to_a
      vowel = 'eyuioa'.split('').to_a
      (1..3).each do
        uname << consonant[rand(consonant.size - 1)]
        uname << vowel[rand(vowel.size - 1)]
      end

      digits = ('0'..'9').to_a
      (1..2).each { uname << digits[rand(digits.size - 1)] }

      redirect_to :action => "show", :user_name => uname
    else
      @user = User.find(:first, :conditions => {:name => uname})

      if @user == nil
        @user = User.new(:name => uname)
        @user.save
      end

      @user.content = '' if @user.content == nil

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end

