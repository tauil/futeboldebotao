module ApplicationHelper
  def title
    content_for(:title).present? ? content_for(:title).concat(' - Rank it') : 'Rank it'
  end

  def description
    content_for(:description) || 'Rank it description'
  end

  def flash_messages
    flash.collect do |key, msg|
      content_tag :p, class: "ui #{key.to_s} flash message" do
        "<i class=\"close icon\"></i>#{msg}".html_safe
      end
    end.join.html_safe
  end
end
