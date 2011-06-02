class PostalCode < ActiveRecord::Base

  def self.autocomplete_search(term, country_code)
    country = case country_code
      when "ca"
        "Canada"
      when "us"
        "United States"
    end

    if country
      PostalCode.where("country = ? AND code LIKE ?", country, "#{ term.upcase }%").limit(20)
    else
      []
    end
  end
  
  def self.search_city_region(term)
    PostalCode.where("city LIKE ?", "#{ term.upcase }%").select([:city, :region]).group([:city, :region]).limit(9)
  end

end