module ApplicationHelper

  def title
    base_title = "BuyBot - Buy your way"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def show_nick
    if current_user.fb_uid.nil?
      current_user.email
    end

    @fb_info.name
  end

end
