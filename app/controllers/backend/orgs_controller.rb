class Backend::OrgsController < ResourcesController
  def create_zx_mct
    load_object
    unless @object.zx_mct
      @object.build_zx_mct
      @object.save
    end
    render action: :edit
  end
end
