class StaticContentsController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_admin

  before_action :set_static_content, only: [:show, :edit, :update, :destroy]

  def authenticate_admin
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  # GET /static_contents
  # GET /static_contents.json
  def index
    @static_contents = StaticContent.all
  end

  # GET /static_contents/1
  # GET /static_contents/1.json
  def show
  end

  # GET /static_contents/new
  def new
    @static_content = StaticContent.new
  end

  # GET /static_contents/1/edit
  def edit
  end

  # POST /static_contents
  # POST /static_contents.json
  def create
    @static_content = StaticContent.new(static_content_params)

    respond_to do |format|
      if @static_content.save
        format.html { redirect_to @static_content, notice: 'Static content was successfully created.' }
        format.json { render :show, status: :created, location: @static_content }
      else
        format.html { render :new }
        format.json { render json: @static_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_contents/1
  # PATCH/PUT /static_contents/1.json
  def update
    respond_to do |format|
      if @static_content.update(static_content_params)
        format.html { redirect_to @static_content, notice: 'Static content was successfully updated.' }
        format.json { render :show, status: :ok, location: @static_content }
      else
        format.html { render :edit }
        format.json { render json: @static_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_contents/1
  # DELETE /static_contents/1.json
  def destroy
    @static_content.destroy
    respond_to do |format|
      format.html { redirect_to static_contents_url, notice: 'Static content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_content
      @static_content = StaticContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def static_content_params
      params.require(:static_content).permit(:name, :data_type, :content)
    end
end
