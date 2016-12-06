class Backend::OrgsController < ResourcesController
  def create_zx_mct
    load_object
    unless @object.zx_mct
      @object.build_zx_mct
      @object.save
    end
    render action: :edit
  end
  def create_merchant
    load_object
    unless @object.merchant
      @object.build_merchant
      @object.save
    end
    render action: :edit
  end
end
