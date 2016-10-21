module Backend
  class ClientsController < BackendController
    before_action :set_client, only: [:show, :edit, :update, :destroy]

    # GET /clients
    # GET /clients.json
    def index
      @collection = Client.all
    end

    # GET /clients/1
    # GET /clients/1.json
    def show
    end

    # GET /clients/new
    def new
      @object = Client.new
    end

    # GET /clients/1/edit
    def edit
    end

    # POST /clients
    def create
      @object = Client.new(client_params)
      @object.tmk = SecureRandom.hex(16).upcase
      if @object.save
        redirect_to @object, notice: "成功创建新商户：#{@object.name}"
      else
        render :new
      end
    end

    # PATCH/PUT /clients/1
    def update
      if @object.update(client_params)
        redirect_to @object, notice: "成功更新商户资料：#{@object.id}##{@object.name}"
      else
        render :edit
      end
    end

    # DELETE /clients/1
    def destroy
      @object.status = 0
      @object.save
      redirect_to clients_url, notice: "停用商户：#{@object.name}"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_client
        @object = Client.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def client_params
        params.require(:client).permit(:name, :org_id, :tmk, :d0_min_fee, :d0_min_percent, :status)
      end
  end
end
