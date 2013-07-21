require 'net/imap'
require 'mail'

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]


  # GET /message
  # GET /message.json
  def index
    @messages = Message.all.desc(:date)
  end

  # GET /message/1
  # GET /message/1.json
  def show
  end

  # GET /message/new
  def new
    @message = Message.new
  end

  # GET /message/1/edit
  def edit
  end

  # POST /message
  # POST /message.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Mail was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /message/1
  # PATCH/PUT /message/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Mail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /message/1
  # DELETE /message/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:subject, :sender, :content, :date, :user_id, :mail_id_uniqueness)
    end
end
