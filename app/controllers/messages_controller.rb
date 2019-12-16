class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /messages
  def index
    @messages = restrict_messages_by_params(Message.all.order(created_at: :desc, id: :desc))

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:from_uid, :to_uid, :body, :is_read)
  end

  def restrict_messages_by_params(messages)
    messages = messages.where(from_uid: params[:from_uid].strip) if params[:from_uid].present?
    messages = messages.where(to_uid: params[:to_uid].strip) if params[:to_uid].present?
    if params[:chat_between].present?
      messages = restrict_to_chat_between_uids(messages,
                                               params[:chat_between].first,
                                               params[:chat_between].last)
    end

    messages
  end

  def restrict_to_chat_between_uids(messages, uid1, uid2)
    messages.where(from_uid: uid1, to_uid: uid2).or(messages.where(from_uid: uid2, to_uid: uid1))
  end
end
