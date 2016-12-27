require 'test_helper'

class ZxMctCellTest < Cell::TestCase
  test "show" do
    html = cell("zx_mct").(:show)
    assert html.match /<p>/
  end


end
