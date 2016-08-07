module ApplicationHelper
  def render_categories_tree(categories, root = true)
    html = '<ul class="nav">'
    categories.each do |category|
      next if root && category.parent_id.present?
      html += "<li><a href='/?category=#{category.name}'>#{category.name}</a></li>"
      html += render_categories_tree(category.children, false) if category.children.present?
    end
    html + '</ul>'
  end

  def render_tags(tags)
    tags.map { |t| " <span class='label label-default'><a href='/?tag=#{t.name}'>#{t.name}</a></span>" }.join
  end

  def flash_class(level)
    case level
      when 'notice' then 'alert alert-info'
      when 'success' then 'alert alert-success'
      when 'error' then 'alert alert-danger'
      when 'alert' then 'alert alert-danger'
    end
  end
end

