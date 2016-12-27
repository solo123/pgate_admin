class SubMctCell < Cell::ViewModel
  def show
    if options[:op] == :edit
      if model.bank_mct && model.bank_mct.is_a?(ZxMct)
        cell(:zx_mct, model.bank_mct)
      else
        "<h2>合众易宝商户数据</h2>"
      end
    else
      render
    end
  end
end
