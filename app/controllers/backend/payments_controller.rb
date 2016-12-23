class Backend::PaymentsController < ResourcesController
  def index
    params[:q] ||= {}
    params[:q][:status_eq] ||= 8
    params[:q][:s] ||= 'order_time desc'
    order_time_gt = params[:q][:order_time_gt]
    order_time_lt = params[:q][:order_time_lt]
    params[:q][:order_time_gt] = order_time_gt.gsub(/\D/,'') if order_time_gt.present?
    params[:q][:order_time_lt] = order_time_lt.gsub(/\D/,'') if order_time_lt.present?
    super
    params[:q][:order_time_gt] = order_time_gt
    params[:q][:order_time_lt] = order_time_lt

  end
end
