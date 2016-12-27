class Backend::OrgsController < ResourcesController
  def create_sub_mct
    load_object
    case params[:bank_type]
    when 'zx'
      sub_mct = @object.sub_mcts.build
      sub_mct.bank_mct = ZxMct.new
      @object.save
      @result = cell(:sub_mct, sub_mct)
    when 'hzyb'
      sub_mct = @object.sub_mcts.build
      sub_mct.bank_mct_type = 'hzyb'
      @object.save
      @result = cell(:sub_mct, sub_mct)
    end
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
