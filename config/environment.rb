# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
ITourSmart::Application.initialize!

require File.expand_path('../../lib/paperclip_processors/cropper.rb', __FILE__)

#WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<img src="/images/prev_label.jpg" alt="Prev page" />'
#WillPaginate::ViewHelpers.pagination_options[:next_label] = '<img src="/images/next_label.jpg" alt="Next page" />'

