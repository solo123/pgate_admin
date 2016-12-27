require 'test_helper'

class ZxContrInfoListCellTest < Cell::TestCase
  test "show" do
    html = cell("zx_contr_info_list").(:show)
    assert html.match /<p>/
  end


end
