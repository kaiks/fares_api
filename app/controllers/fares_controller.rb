class FaresController < ApplicationController
  before_action :set_fare, only: [:update, :destroy]
  has_scope :price_from
  has_scope :price_to
  has_scope :by_period, using: [:from, :to], type: :hash

  # GET /fares
  def index
    @fares = apply_scopes(Fare.order(:id))
    set_pagination

    render json: @fares
  end

  # POST /fares
  def create
    @fare = Fare.new(fare_params)

    if @fare.save
      render json: @fare, status: :created, location: @fare
    else
      render json: @fare.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fares/1
  def update
    if @fare.update(fare_params)
      render json: @fare
    else
      render json: @fare.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fares/1
  def destroy
    @fare.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fare
    @fare = Fare.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def fare_params
    params.fetch(:fare, {}).permit(:currency, :price,
                                   :valid_from, :valid_to,
                                   :container_type, :source, :destination)
  end

  def set_pagination
    zero_based_page = params.fetch(:page, 1).to_i - 1
    pagination_offset = zero_based_page*PAGE_SIZE
    @fares = @fares.limit(PAGE_SIZE).offset(pagination_offset)
  end
end
