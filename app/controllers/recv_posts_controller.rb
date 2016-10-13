class RecvPostsController < ResourcesController
  def send_all_notifies
    RecvPost.not_send.each do |p|
      if p.method == 'tfb'
        Biz::TfbApi.send_notify(p)
      end
    end
    #KaifuResult.not_send.each {|r| biz.notify_client(r)}
    redirect_to action: :index
  end
end
