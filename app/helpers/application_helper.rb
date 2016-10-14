module ApplicationHelper
  def string_2_datetime_format(s)
    "#{s[0..3]}-#{s[4..5]}-#{s[6..7]} #{s[8..9]}:#{s[10..11]}:#{s[12..13]}"
  end
end
