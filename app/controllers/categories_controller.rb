# frozen_string_literal: true

class CategoriesController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_user_role

  before_action :set_category, only: %i[show edit update destroy]

  def authenticate_user_role
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  # GET /categories
  # GET /categories.json
  def index
    @order = params[:order].present? ? params[:order].to_sym : :id
    @categories = Category.all.order(@order)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new(parent_id: params[:parent_id])
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :parent_id, :icon_name, :active, :position,
                                       contact_attributes: %i[email], tag_list: [])
    end
end
