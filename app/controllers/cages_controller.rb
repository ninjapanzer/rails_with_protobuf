class CagesController < ApplicationController
  before_action :set_cage, only: [:show, :update, :destroy]
  requires_roles roles: [Protos::Actor::Role::ROLE_BUILDER, Protos::Actor::Role::ROLE_SCIENTIST]

  # GET /cages
  def index
    @cages = Cage.all

    render json: @cages
  end

  # GET /cages/1
  def show
    if params[:status]
      @cage = @cage.where(status: params[:status])
    end

    render json: CageSerializer.new(@cage).serialize
  end

  # Get /cages/1/dinosaurs
  def dinosaurs
    @cage = Cage.find(params[:cage_id])
    render json: CageSerializer.new(@cage, :with_dinosaurs).serialize
  end

  # POST /cages
  def create
    @cage = Cage.new(cage_params)

    if @cage.save
      render json: @cage, status: :created, location: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cages/1
  def update
    if @cage.update(cage_params)
      render json: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cages/1
  def destroy
    @cage.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cage
      @cage = Cage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cage_params
      params.require(:cage).permit(:name, :status, :capacity)
    end
end
