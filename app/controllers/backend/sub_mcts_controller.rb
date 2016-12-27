class Backend::SubMctsController < ResourcesController
	def update
		load_object
		params.permit!
		@object.attributes = params[object_name.singularize.parameterize('_')]
		if @object.changed_for_autosave?
			#@changes = @object.all_changes
			if @object.save
			else
				flash[:error] = @object.errors.full_messages.to_sentence
				@no_log = 1
			end
		end
    case params[:commit]
    when '进件'
      biz = Biz::HzIntfcApi.new(@object)
      biz.intfc_request_xml
      biz.send_to_hzyb
      if biz.err_code == '00'
        flash[:info] = '进件成功, message:' + biz.err_desc
      else
        flash[:error] = biz.err_desc
      end
    when '进件信息修改'
      biz = Biz::HzIntfcApi.new(@object)
      biz.modify_request_xml
      biz.send_to_hzyb
      if biz.err_code == '00'
        flash[:info] = '进件信息修改, message:' + biz.err_desc
      else
        flash[:error] = biz.err_desc
      end
    when '查询'
      biz = Biz::HzIntfcApi.new(@object)
      biz.send_zx_query
      flash[:error] = biz.err_desc unless biz.err_code == '00'
    end
    redirect_to edit_org_path(@object.org)
	end
end
