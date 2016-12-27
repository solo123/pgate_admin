require "cell/partial"
class ZxMctCell < Cell::ViewModel
  include ActionView::Helpers::FormOptionsHelper
  include Partial
  def show
    render
  end

end
