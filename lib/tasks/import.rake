require 'csv'
require 'hpricot'
require "open-uri"

namespace :import do
  task :org_seeds => :environment do
    Organization.after_create.clear

    #Output Header
    puts "Importing org_seeds.txt (tab-delimited text file) from s3"
    puts "expected formatting"
    puts "row[0] = aba_id"
    puts "row[1] = syta_id"
    puts "row[2] = name"
    puts "row[3] = line_1"
    puts "row[4] = line_2"
    puts "row[5] = city"
    puts "row[6] = region"
    puts "row[7] = postal_code"
    puts "row[8] = phone"
    puts "row[9] = fax"
    puts "row[10] = aba_email"
    puts "row[11] = syta_email"
    puts "row[12] = url"
    puts "row[13] = master_type"
    puts "row[14] = category"
    puts "row[15] = country"
    puts "row[16] = aba_primary_contact"
    puts "row[17] = acronym"
    puts "row[18] = nta_member"
    puts ""
    
    ####################  ABA        
    puts "Will create record for American Bus Association if needed"

    aba = Organization.find_or_create_by_name("American Bus Association")
    unless aba.categorizations.size > 0 
      #aba.master_type = "association"
      aba.acronym = "ABA"
      assoc_category_id = Category.find_or_create_by_name('Trade Association').id 
      aba.categorizations.build(:category_id => assoc_category_id, :is_verified => true)
      aba_location = aba.locations.build(:name => "Headquarters")
      aba_location.build_address(:line_1 => "111 K Street NE", :line_2 => "9th Floor", :city => "Washington", :region => "DC", :postal_code => "20002", :country => "United States")
      aba.save
      puts "Created categorization for ABA"
    end
    aba_id = aba.id
    puts "American Bus Association organization id is #{aba_id}"
    puts ""
    
    ####################  SYTA
    puts "Will create record for Student & Youth Travel Association if needed"

    syta = Organization.find_or_create_by_name("Student & Youth Travel Association")
    unless syta.categorizations.size > 0 
      #syta.master_type = "association"
      syta.acronym = "SYTA"
      assoc_category_id = Category.find_or_create_by_name('Trade Association').id #find corresponding category_id
      syta.categorizations.build(:category_id => assoc_category_id, :is_verified => true) #build new categorization
      syta_location = syta.locations.build(:name => "Headquarters")
      syta_location.build_address(:line_1 => "8400 Westpark Drive", :line_2 => "2nd Floor", :city => "McLean", :region => "VA", :postal_code => "22102", :country => "United States")
      syta.save
      syta_location.save
      puts "Created categorization for SYTA"
    end
    syta_id = syta.id
    puts "Student Youth Travel Association organization id is #{syta_id}"
    puts ""
    
    ####################  NTA
    nta = Organization.find_or_create_by_name("National Tour Association")
    unless nta.categorizations.size > 0 
      #nta.master_type = "association"
      nta.acronym = "NTA"
      assoc_category_id = Category.find_or_create_by_name('Trade Association').id #find corresponding category_id
      nta.categorizations.build(:category_id => assoc_category_id, :is_verified => true) #build new categorization
      nta_location = nta.locations.build(:name => "Headquarters")
      nta_location.build_address(:line_1 => "101 Prosperous Place", :line_2 => "Suite 350", :city => "Lexington", :region => "KY", :postal_code => "40509", :country => "United States")
      nta.save
      nta_location.save
      puts "Created categorization for NTA"
    end
    nta_id = nta.id
    puts "National Tour Association organization id is #{nta_id}"
    puts ""
    
    #Initialize the counters
    rows_added = 0
    rows_skipped = 0
    rows_updated = 0
    
    
    ################################################################
    #Initialize the counters
    rows_added = 0
    rows_skipped = 0
    rows_updated = 0
    
    ####################  PARSE TIME ###############################
    #Ruby's built in CSV Parser
    url = "https://s3.amazonaws.com/its_seeds/org_seeds.txt"
    CSV.foreach(open(url),:col_sep => "\t") do |row|
      unless row[0].blank? && row[1].blank?
        if !row[0].blank?
          organization = Organization.find_by_aba_id(row[0])
        else
          organization = Organization.find_by_syta_id(row[1])
        end
        if !organization.blank?
          puts "duplicate found"
          category_id = Category.find_or_create_by_name(row[14]).id
          if !row[1].blank? && !organization.is_student_friendly
            organization.is_student_friendly = true
            organization.save
          end
          if organization.categorizations.any? {|c| c.category_id == category_id}
            puts "*****skipped duplicate | #{row[2].ljust(150)}"
            rows_skipped += 1
          else
            organization.categorizations.create(:category_id => category_id) #build new categorization
            puts "added category #{row[14]} to #{row[2]}"
            puts "#{organization.categorizations.each.inspect}"
            rows_updated += 1
          end
        else
          organization = Organization.new do |org|
            org.aba_id = row[0].strip unless row[0].blank?
            org.syta_id = row[1].strip unless row[1].blank?
            org.name = row[2].strip unless row[2].blank?
            org.aba_email = row[10].strip unless row[10].blank?
            org.syta_email = row[11].strip unless row[11].blank?
            org.url = row[12].strip unless row[12].blank?
            #org.master_type = row[13].strip unless row[13].blank?
            org.aba_contact = row[16].strip unless row[16].blank?
            org.acronym = row[17].strip unless row[17].blank?
            line_1 = row[3].strip unless row[3].blank?
            line_2 = row[4].strip unless row[4].blank?
            city = row[5].strip unless row[5].blank?
            region = row[6].strip unless row[6].blank?
            postal_code = row[7].strip unless row[7].blank?
            country = row[15].strip unless row[15].blank?
            org.is_student_friendly = true unless row[1].blank?
            org.is_motorcoach_friendly = true
            org.is_nta_member = true unless row[18].blank?
         
            org.locations.build do |l|
              l.name = row[5].strip unless row[5].blank?
              l.is_active = "true"
            
              addr = l.build_address(:line_1 => line_1, :line_2 => line_2, :city => city, :region => region, :postal_code => postal_code, :country => country) 
            end          
            category_id = Category.find_or_create_by_name(row[14]).id  
            org.categorizations.build(:category_id => category_id , :is_verified => true) unless category_id.blank?
            puts "ABA ID is #{org.aba_id}" unless org.aba_id.blank?
            org.association_memberships.build(:organization_id => aba_id) unless org.aba_id.blank?
            puts "SYTA ID is #{org.syta_id}" unless org.syta_id.blank?
            org.association_memberships.build(:organization_id => syta_id) unless org.syta_id.blank?
            puts "Org is NTA Member" unless org.is_nta_member.blank?
            org.association_memberships.build(:organization_id => nta_id) unless org.is_nta_member.blank?
            puts "#{org.name.ljust(150)} | #{org.id.to_s.rjust(10)}"
            rows_added += 1
            org.save(false)
          end
        end
      end
    end
    puts "#{rows_added} rows added"
    puts "#{rows_updated} rows updated"
    puts "#{rows_skipped} rows skipped"
  end


### legacy import postal_code task
#
#  task :codes => :environment do
#    #Ruby's built in CSV Parser
#    URL = "https://s3.amazonaws.com/its_seeds/its_postal_codes.csv"
#    open(URL) do |file|
#      CSV.parse(file.read) do |row|
#        postal_code = PostalCode.new do |pcode|
#          pcode.code = row[0] unless row[0].blank? 
#          pcode.city = row[1] unless row[1].blank? 
#          pcode.region = row[2] unless row[2].blank? 
#          unless row[3].blank?
#            # is db has been migrated from type to tipe?
#            if pcode.respond_to?(:tipe)
#              pcode.tipe = row[3]
#            else
#              pcode.type = row[3]
#            end
#          end
#          pcode.lat = row[4] unless row[4].blank? 
#          pcode.lng = row[5] unless row[5].blank? 
#          pcode.country = row[6] unless row[6].blank?
#          pcode.save
#        end
#      end
#    end

  desc "run this task with rake import:codes source=file to use file on RAILS_ROOT/../its_postal_codes.csv"
  task :codes => :environment do

    # improve import time, see https://github.com/zdennis/activerecord-import/wiki/Benchmarks
    require 'activerecord-import'

    puts "make sure to migrate db before to rename type column to tipe"

    url = if ENV['source'] == 'file'
      puts "make sure csv file is present on RAILS_ROOT/../its_postal_codes.csv"
      puts "use offset=339 (in thousands) option if resuming importing data."
      File.join(Rails.root, '..', 'its_postal_codes.csv')
    else
      puts "using data from Amazon s3"
      "https://s3.amazonaws.com/its_seeds/its_postal_codes.csv"
    end

    offset = ENV['offset'].to_i

    # don't log db inserts
    ActiveRecord::Base.logger.level = Logger::ERROR

    open(url) do |file|
      columns = [:code, :city, :region, :tipe, :lat, :lng, :country]
      values  = []
      row_num = 0
      iteration = 0
      
      CSV.parse(file) do |row|
        # cheat import, use offset to set resume importing from
        if offset && offset > 0
          if row_num <= (offset*1000)
            row_num += 1
            next
          elsif row_num == ((offset*1000)+1)
            puts "restarting up"
            row_num += 1
            iteration = offset
            offset = nil
          end
        end
      
        # blank country & non-Canada is always USA
        # actual row[6] data of US postal code is County name
        if row[6].blank? || row[6] != 'Canada'
          row[6] = 'United States'
          # is city data exists? titleize the city
          if row[1].present?
            row[1] = row[1].to_s.titleize
          end
        end
        values << row
        
        # flush to database every 1000 items, actual data count is 808.085
        if values.size == 1000
          puts "writing offset %d.000" % (iteration += 1)
          PostalCode.import columns, values
          values.clear
        end
        
      end
      
      #left-over data
      puts "writing %d of left-over data" % values.size
      if not values.empty?
        PostalCode.import columns, values
        values.clear
      end
    end

  end
end