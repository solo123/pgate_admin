class Backend::ZxMctsController < ResourcesController
  def update
    load_object
    params.permit!
    @object.attributes = params[:zx_mct]
    if @object.changed_for_autosave?
      if @object.save
        flash[:info] = "数据保存成功"
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    case params[:commit]
    when '发送到中信银行'
      biz = Biz::ZxIntfcApi.new(@object.org)
      biz.prepare_request
      if biz.err_code == '00'
        biz.send_zx_intfc
        flash[:error] = biz.err_desc unless biz.err_code == '00'
      else
        flash[:error] = biz.err_desc
      end
    when '查询'
      biz = Biz::ZxIntfcApi.new(@object.org)
      biz.send_zx_query
      flash[:error] = biz.err_desc unless biz.err_code == '00'
    end
    redirect_to edit_org_path(@object.org)
  end

end
