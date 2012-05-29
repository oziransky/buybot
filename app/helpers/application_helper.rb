module ApplicationHelper

  def title
    base_title = "BuyBot - Buy your way"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def link_to_submit(text, id, class_name)
    link_to_function text, "$(this).closest('form').submit()", :id => id, :class => class_name
  end

end
