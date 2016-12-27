require 'test_helper'

class SubMctCellTest < Cell::TestCase
  test "show" do
    html = cell("sub_mct").(:show)
    assert html.match /<p>/
  end

  test "sub_mcts" do
    html = cell("sub_mct").(:sub_mcts)
    assert html.match /<p>/
  end


end
