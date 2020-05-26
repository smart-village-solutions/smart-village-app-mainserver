# frozen_string_literal: true

class AppUserContentsController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_admin

  before_action :set_app_user_content, only: %i[show edit update destroy]

  def authenticate_admin
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  # GET /app_user_contents
  # GET /app_user_contents.json
  def index
    @app_user_contents = AppUserContent.all
  end

  # GET /app_user_contents/1
  # GET /app_user_contents/1.json
  def show
  end

  # GET /app_user_contents/new
  def new
    @app_user_content = AppUserContent.new
  end

  # GET /app_user_contents/1/edit
  def edit
  end

  # POST /app_user_contents
  # POST /app_user_contents.json
  def create
    @app_user_content = AppUserContent.new(app_user_content_params)

    respond_to do |format|
      if @app_user_content.save
        format.html do
          redirect_to @app_user_content,
                      notice: "App User Content was successfully created."
        end
        format.json { render :show, status: :created, location: @app_user_content }
      else
        format.html { render :new }
        format.json { render json: @app_user_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_user_contents/1
  # PATCH/PUT /app_user_contents/1.json
  def update
    respond_to do |format|
      if @app_user_content.update(app_user_content_params)
        format.html do
          redirect_to @app_user_content,
                      notice: "App User Content was successfully updated."
        end
        format.json { render :show, status: :ok, location: @app_user_content }
      else
        format.html { render :edit }
        format.json { render json: @app_user_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_user_contents/1
  # DELETE /app_user_contents/1.json
  def destroy
    @app_user_content.destroy
    respond_to do |format|
      format.html do
        redirect_to app_user_contents_url,
                    notice: "App User Content was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_app_user_content
      @app_user_content = AppUserContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_user_content_params
      params.require(:app_user_content).permit(:data_source, :data_type, :content)
    end
end
