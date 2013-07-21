require 'mail'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :get_mail, only: [:show]
  after_action  :get_mail, only: [:create]
  after_action :validate_email, only: [:create]
  after_action :validate_email, only: [:show, :edit, :update]
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :is_correct_user, :only => [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.where(:id => params[:id]).first
    @messages = @user.messages.desc(:date)
    @titre = @user.name
  end

  # GET /users/new
  def new
    @user = User.new
    @titre = "S'inscrire"
  end

  # GET /users/1/edit
  def edit
    @titre = "Édition profil"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'Logged in correctly' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :imap_server, :port_server)
    end

    def authenticate
      deny_access unless signed_in?
    end

    def is_correct_user
      @user = User.where(:id => params[:id]).first
      redirect_to(root_path) unless current_user?(@user)
    end

    def get_mail
      flash[:notice] = "Downloading mails"
      system "rake receive_mails USER_DATA=#{@user._id} & "
      if (flash.keep[:error].blank?)
        flash[:notice] = "Updated at #{Time.now}"
      end
    end

    def validate_email
      if (Message.validate_account(@user) == false)
        flash[:error] = "Invalid account settings"
      else
        flash[:error] = ""
        flash[:notice] = "Updated at #{Time.now}"
      end
    end
end
