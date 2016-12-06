class Backend::ZxMctsController < ResourcesController
  def update
    load_object
    params.permit!
    @object.attributes = params[:zx_mct]
    if @object.changed_for_autosave?
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    if params[:commit] == '发送到中信银行'
      flash[:alert] = "已经发送给银行"
      biz = Biz::ZxIntfcApi.new(@object.org)
      biz.prepare_request
      @xml = biz.xml
      url = AppConfig.get('zx', 'intfc_url')
      pd = Biz::WebBiz.post_xml('zx_intfc', url, @xml, @object)
      @post_data = pd
      render 'send_to_zx'
    else
      redirect_to edit_org_path(@object.org)
    end
  end

end
