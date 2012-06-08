module ApplicationHelper

  def title
    base_title = "BuyBot - Buy your way"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
