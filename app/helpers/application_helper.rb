module ApplicationHelper

  def tab_link(link_name, link_path)
    active_class = current_page?(link_path) ? "active" : ""
    content_tag(:li, class: active_class) do
      link_to link_name, link_path
    end
  end
  
end
