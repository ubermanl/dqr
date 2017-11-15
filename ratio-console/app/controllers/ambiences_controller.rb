class AmbiencesController < ApplicationController
  before_action :set_ambience, only: [:show, :edit, :update, :destroy]

  # GET /ambiences
  # GET /ambiences.json
  def index
    @ambiences = Ambience.all
  end

  # GET /ambiences/1
  # GET /ambiences/1.json
  def show
  end

  # GET /ambiences/new
  def new
    @ambience = Ambience.new
  end

  # GET /ambiences/1/edit
  def edit
  end

  # POST /ambiences
  # POST /ambiences.json
  def create
    @ambience = Ambience.new(ambience_params)

    respond_to do |format|
      if @ambience.save
        format.html { redirect_to @ambience, notice: 'Ambience was successfully created.' }
        format.json { render :show, status: :created, location: @ambience }
      else
        format.html { render :new }
        format.json { render json: @ambience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ambiences/1
  # PATCH/PUT /ambiences/1.json
  def update
    respond_to do |format|
      if @ambience.update(ambience_params)
        format.html { redirect_to @ambience, notice: 'Ambience was successfully updated.' }
        format.json { render :show, status: :ok, location: @ambience }
      else
        format.html { render :edit }
        format.json { render json: @ambience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ambiences/1
  # DELETE /ambiences/1.json
  def destroy
    @ambience.destroy
    respond_to do |format|
      format.html { redirect_to ambiences_url, notice: 'Ambience was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::DeleteRestrictionError => er
    respond_to do |format|
      flash[:error] = 'Cannot be deleted, some devices depend on it'
      format.html { redirect_to ambiences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ambience
      @ambience = Ambience.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ambience_params
      params.require(:ambience).permit(:name, :is_deleted)
    end
end