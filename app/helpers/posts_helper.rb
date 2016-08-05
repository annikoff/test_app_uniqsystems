module PostsHelper
  def render_user_name_and_time(record)
     " #{distance_of_time_in_words(record.created_at, Time.now)} ago"
  end
end
