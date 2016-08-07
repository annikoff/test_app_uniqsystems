module PostsHelper
  def render_user_name_and_time(record)
     " #{distance_of_time_in_words(record.created_at, Time.now)} ago"
  end

  def url_params
    params.permit(:order, :category, :tag)
  end

  def merge_order_params(order)
    url_params.merge(order: (order == 'desc' ? 'asc' : 'desc'))
  end
end
