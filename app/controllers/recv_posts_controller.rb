class RecvPostsController < ResourcesController
  def send_all_notifies
    biz = Biz::WebBiz.new
    RecvPost.not_send.each {|p| p.check_is_valid_notify }
    KaifuResult.not_send.each {|r| biz.notify_client(r)}
    redirect_to action: :index
  end
end
