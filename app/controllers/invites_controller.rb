# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invite, only: %i[show update destroy]

  # GET /invites
  def index
    @invites = restrict_resources_by_params(Invite.all)

    render json: @invites
  end

  # GET /invites/1
  def show
    render json: @invite
  end

  # POST /invites
  def create
    @invite = Invite.new(invite_params)

    if @invite.save
      render json: @invite, status: :created, location: @invite
    else
      render json: @invite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invites/1
  def update
    if @invite.update(invite_params)
      render json: @invite
    else
      render json: @invite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invites/1
  def destroy
    @invite.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invite
    @invite = Invite.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def invite_params
    params.require(:invite).permit(:from_uid, :to_address)
  end

  def restrict_resources_by_params(resources)
    resources = super(resources)
    resources = resources.where(from_uid: params[:from_uid].strip) if params[:from_uid].present?
    resources
  end
end
