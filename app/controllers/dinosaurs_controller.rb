class DinosaursController < ApplicationController
  before_action :set_dinosaur, only: [:show, :update, :destroy]
  requires_roles roles: [Protos::Actor::Role::ROLE_SCIENTIST]

  # GET /dinosaurs
  def index
    @dinosaurs = Inhabitant.dinosaur.all

    if params[:species]
      @dinosaurs = @dinosaurs.where(species: params[:species])
    end

    if params[:diet]
      @dinosaurs = @dinosaurs.where(diet: params[:diet])
    end

    render json: @dinosaurs
  end

  # GET /dinosaurs/1
  def show
    render json: @dinosaur
  end

  def create
    @dinosaur = Inhabitant.new(dinosaur_params)

    if @dinosaur.save
      render json: @dinosaur, status: :created
    else
      render json: @dinosaur.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dinosaurs/1
  def update
    if @dinosaur.update(dinosaur_params)
      render json: @dinosaur
    else
      render json: @dinosaur.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dinosaurs/1
  def destroy
    @dinosaur.destroy
    head :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_dinosaur
    @dinosaur = Inhabitant.dinosaur.find(params[:id])
  end

  def dinosaur_params
    params.require(:dinosaur).permit(:name, :species, :diet)
  end
end
