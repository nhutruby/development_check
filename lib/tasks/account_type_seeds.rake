require 'seed-fu/writer'

namespace :account_type_seeds do
  task :build => :environment do
    list = AccountType.all
    SeedFu::Writer.write('db/fixtures/account_types.rb', :class_name => 'AccountType') do |writer|
      list.each do |item|
        writer << item.attributes
      end
    end
  end
end