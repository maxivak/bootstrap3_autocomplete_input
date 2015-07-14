class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  autocomplete :client, :name

  def temp_autocomplete_client_name
    a = [["123","First"],["456","Second"], ["3", "Third"]]
    render :json => a.to_json
  end

  # GET /clients
  def index
    @clients = Client.all
  end

  # GET /clients/1
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params[:client].permit(:name)
    end
end
