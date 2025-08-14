Rails.application.config.after_initialize do
  ActionText::ContentHelper.allowed_attributes = Set.new ['style']
  # To allow iframe in ActionText
  ActionText::ContentHelper.allowed_tags = Set.new ["iframe"]
end
