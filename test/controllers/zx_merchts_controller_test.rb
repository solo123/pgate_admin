require 'test_helper'

class ZxMerchtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zx_mercht = zx_merchts(:one)
  end

  test "should get index" do
    get zx_merchts_url
    assert_response :success
  end

  test "should get new" do
    get new_zx_mercht_url
    assert_response :success
  end

  test "should create zx_mercht" do
    assert_difference('ZxMercht.count') do
      post zx_merchts_url, params: { zx_mercht: { chnl_id: @zx_mercht.chnl_id, chnl_mercht_id: @zx_mercht.chnl_mercht_id } }
    end

    assert_redirected_to zx_mercht_url(ZxMercht.last)
  end

  test "should show zx_mercht" do
    get zx_mercht_url(@zx_mercht)
    assert_response :success
  end

  test "should get edit" do
    get edit_zx_mercht_url(@zx_mercht)
    assert_response :success
  end

  test "should update zx_mercht" do
    patch zx_mercht_url(@zx_mercht), params: { zx_mercht: { chnl_id: @zx_mercht.chnl_id, chnl_mercht_id: @zx_mercht.chnl_mercht_id } }
    assert_redirected_to zx_mercht_url(@zx_mercht)
  end

  test "should destroy zx_mercht" do
    assert_difference('ZxMercht.count', -1) do
      delete zx_mercht_url(@zx_mercht)
    end

    assert_redirected_to zx_merchts_url
  end
end
