class TxnsController < ApplicationController
  before_action :set_txn, only: [:show, :edit, :update ]
  include Phobos::Producer

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
    @txn_type_list = TxnType.all
    @bank_list = Bank.all
  end

  # GET /txns/1/edit
  def edit
  end

  # POST /txns
  # POST /txns.json
  def create
    unless ENV["IS_SIDEKIQ"]
      @txn = Txn.new(txn_params)
      @txn.txn_status_id = 1
      @txn.user_id = 1
    end

    respond_to do |format|
      ## Need to check for validity
      if ENV["IS_SIDEKIQ"]
        @txn = Txn.create!(txn_params)
        EventFiringJob.perform_async(@txn.id, "check")
      else
        if txn.save
          self.producer.publish(
            topic: 'txn.created',
            payload: @txn.to_json,
          )
        end
      end

      format.html { redirect_to @txn, notice: 'Txn was successfully created.' }
      format.json { render :show, status: :created, location: @txn }
    end
  end

  # PATCH/PUT /txns/1
  # PATCH/PUT /txns/1.json
  def update
    respond_to do |format|
      if @txn.update(txn_params)
        format.html { redirect_to @txn, notice: 'Txn was successfully created.' }
        format.json { render :show, status: :created, location: @txn }
      else
        @txn_type_list = TxnType.all
        @bank_list = Bank.all
        format.html { render :new }
        format.json { render json: @txn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /txns/1
  # PATCH/PUT /txns/1.json
  # def update
  #   respond_to do |format|
  #     if @txn.update(txn_params)
  #       format.html { redirect_to @txn, notice: 'Txn was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @txn }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @txn.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /txns/1
  # DELETE /txns/1.json
  def destroy
    @txn.destroy
    respond_to do |format|
      format.html { redirect_to txns_url, notice: 'Txn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_txn
      @txn = Txn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def txn_params
      params.require(:txn).permit(:amt, :txn_status_id, :txn_type_id, :user_id, :src_bank_id, :dst_bank_id)
    end
end
