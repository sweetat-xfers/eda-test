class TxnsController < ApplicationController
  before_action :set_txn, only: [:show, :update]

  # GET /txns
  # GET /txns.json
  def index
    @txns = Txn.all
  end

  # GET /txns/1
  # GET /txns/1.json
  def show
  end

  # GET /txns/new
  def new
    @txn = Txn.new
  end

  # POST /txns
  # POST /txns.json
  def create
    @txn = Txn.new(txn_params)

    respond_to do |format|
      if @txn.save
        format.html { redirect_to @txn, notice: 'Txn was successfully created.' }
        format.json { render :show, status: :created, location: @txn }
      else
        format.html { render :new }
        format.json { render json: @txn.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates should only allow users to cancel txn
  # PATCH/PUT /txns/1
  # PATCH/PUT /txns/1.json
  def update
    respond_to do |format|
      if @txn.update(txn_params)
        format.html { redirect_to @txn, notice: 'Txn was successfully updated.' }
        format.json { render :show, status: :ok, location: @txn }
      else
        format.html { render :edit }
        format.json { render json: @txn.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_txn
      @txn = Txn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def txn_params
      params.require(:txn).permit(:txn_status_id, :txn_type_id, :user_id, :src_bank_id, :dst_bank_id, :amt)
    end
end
