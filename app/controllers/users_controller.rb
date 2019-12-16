# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[update destroy]

  # GET /users
  def index
    @users = restrict_resources_by_params(User.all)

    render json: @users
  end

  # GET /users/1
  def show
    @user = !params[:id].nil? ? @user = User.find_by_uid(params[:id]) : current_user # for `/profile` there is no ID
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_uid(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :status, :password)
  end

  def restrict_resources_by_params(resources)
    resources = super(resources)
    resources = resources.where(uid: params[:uid].strip) if params[:uid].present?
    resources
  end
end
