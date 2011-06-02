require 'seed-fu/writer'

namespace :page_seeds do
  task :build => :environment do
    p = Page.all
      puts "Page.seed(:id,"
    p.each do |page|
      puts "{:id => '#{page.id}', :name => '#{page.name}', :permalink => '#{page.permalink}', :content => \"#{page.content.html_safe}\"}," 
    end
    puts ")"

  end
end