class LocationSearchController < ApplicationController
  #Devise Authentication
  before_filter :authenticate_user!
    

  def load_filter_data
    @categories = Category.all

      #list  = Address.select([:city, :region, :country, :updated_at]).group([:city, :region, :country, :updated_at]).order(:city).all

      Address.send(:with_exclusive_scope) {
        @addresses = Address.select([:city, :region, :country]).group([:city, :region, :country]).order(:city).all
      }

      @countries = @addresses.map { |a| a.country }.compact.uniq - ["United States", "Canada"]
      @cities    = @addresses.map { |a| [a.city, a.region].join(", ") }.compact.uniq - [
                        "New York, NY",
                        "Orlando, FL",
                        "Washington, DC",
                        "Chicago, IL",
                        "Los Angeles, CA"
                      ]
  end
  protected :load_filter_data

  def filtered_search?
    params[:query] || params[:filters]
  end
  protected :filtered_search?

  def filtered_search
    @search_results = Location.solr_search do
      # default keyword search
      searched_fields = [
        :organization_name,
        :organization_name_substring,
        :location_name,
        :address_line1,
        :address_line2,
        :address_zipcode,
        :keywords,
        :category_tags
      ]

      all_of do
        if filter_available?(:category_ids)
          with(:category_ids).any_of(params[:filters][:category_ids])
        else
          searched_fields << :categories
        end

        if filter_available?(:country)
          with(:country).any_of(params[:filters][:country])
        else
          searched_fields << :address_country
        end

        if filter_available?(:city_region)
          with(:city_region).any_of(params[:filters][:city_region])
        else
          searched_fields << :address_city
          searched_fields << :address_state
        end

        if filter_available?(:is_student_friendly)
          with(:is_student_friendly, true)  
        end

        if filter_available?(:is_motorcoach_friendly)
          with(:is_motorcoach_friendly, true)
        end
        
        with(:is_active, true)

##        # can't make this work
##        # the keywords from search query are space separated
##        if params[:query].present?
##          with(:tags).any_of(params[:query].split(' '))
##        end
      end

      keywords params[:query], :fields => searched_fields, :minimum_match => '2'

      adjust_solr_params do |solr_params|
        logger.info "Adjusting solr params with spellcheck.q=#{params[:query]}"
        solr_params["spellcheck.q"] = params[:query]
      end
      
      paginate :page => params[:page], :per_page => 15
    end
    @locations = @search_results.results
    @total = @locations.total_entries
  end
  protected :filtered_search

  def filter_available?(group)
    params[:filters] && params[:filters][group] && !params[:filters][group].empty?
  end
  protected :filter_available?

  def quick_search
    @search_results = Location.solr_search do
      keywords "#{params[:search]}"
      order_by :rating, :desc

      paginate :page => params[:page], :per_page => 15
    end
    @locations = @search_results.results
  end
  protected :quick_search

  def advanced_search
    @search_results = Location.solr_search do
      keywords "#{params[:organization_name]}", :fields => ["organization_name"]
      keywords "#{params[:location]}", :fields => ["location_name"]
      keywords "#{params[:address1]}", :fields => ["address_line1"]
      keywords "#{params[:address2]}", :fields => ["address_line2"]
      keywords "#{params[:city]}", :fields => ["address_city"]
      keywords "#{params[:state]}", :fields => ["address_state"]
      keywords "#{params[:zipcode]}", :fields => ["address_zipcode"]
      keywords "#{params[:country]}", :fields => ["address_country"]
      keywords "#{params[:category]}", :fields => ["categories"]
      order_by :rating, :desc

      paginate :page => params[:page], :per_page => 10
    end
    @locations = @search_results.results
  end
  protected :advanced_search

  def advanced_search?
    !(params[:organization_name].nil? && params[:location].nil? && params[:address1].nil? && params[:address2].nil? && params[:city].nil? && params[:state].nil? && params[:zipcode].nil? && params[:country].nil? && params[:category].nil?)
  end
  protected :advanced_search?
end