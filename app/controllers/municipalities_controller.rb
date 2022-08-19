# frozen_string_literal: true

class MunicipalitiesController < AdminController
  before_action :set_municipality, only: %i[ show edit update destroy ]

  # GET /municipalities or /municipalities.json
  def index
    @municipality_suggestion = params[:municipality_suggestion]
    @municipalities = Municipality.all
  end

  # GET /municipalities/1 or /municipalities/1.json
  def show
  end

  # GET /municipalities/new
  def new
    @municipality = Municipality.new
  end

  # GET /municipalities/1/edit
  def edit
  end

  # POST /municipalities or /municipalities.json
  def create
    @municipality = Municipality.new(municipality_params)

    respond_to do |format|
      if @municipality.save
        format.html { redirect_to municipality_url(@municipality), notice: "Municipality was successfully created." }
        format.json { render :show, status: :created, location: @municipality }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /municipalities/1 or /municipalities/1.json
  def update
    respond_to do |format|
      if @municipality.update(municipality_params)
        format.html { redirect_to municipality_url(@municipality), notice: "Municipality was successfully updated." }
        format.json { render :show, status: :ok, location: @municipality }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1 or /municipalities/1.json
  def destroy
    # Aus Sicherheitsgründen erst einmal deaktiviert
    # Wenn eine Kommune gelöscht werden soll müssen vermutlich auch
    # alle zugehörigen Einträge gelöscht werden
    # @municipality.destroy

    respond_to do |format|
      # format.html { redirect_to municipalities_url, notice: "Municipality was successfully destroyed." }
      format.html { redirect_to municipalities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_municipality
      @municipality = Municipality.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def municipality_params
      params.require(:municipality).permit(:slug, :title, :settings)
    end
end
