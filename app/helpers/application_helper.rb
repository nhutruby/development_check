module ApplicationHelper

  include DynamicChildFieldsHelper
  
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

  def major_currencies(hash)
    hash.inject([]) do |array, (id, attributes)|
      priority = attributes[:priority]
      if priority && priority < 10
        array[priority] ||= []
        array[priority] << id
      end
      array
    end.compact.flatten
  end

  # Returns an array of all currency id
  def all_currencies(hash)
    hash.keys
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def current_announcements
    unless session[:announcement_hide_time].nil?
      time = session[:announcement_hide_time]
    else
      time = cookies[:announcement_hide_time].to_datetime unless cookies[:announcement_hide_time].nil?
    end
    @current_announcements ||= Announcement.current_announcements(time)
  end

 def google_map
    content_for :maps do
      javascript_include_tag("http://maps.google.com/maps/api/js?sensor=false&hl=en")+
      javascript_include_tag("maps")
    end
  end

  def getOrganizationType(organization)
    if organization.categories.blank?
      "#006400"
    else
      organization.categories.first.color
    end
  end

  def alpha_links(action)
    return_text = ""
    query = params.clone
    query.delete(:search)
    ('A'..'Z').to_a.each do |letter|
      return_text = return_text + "|" + link_to(
      " #{letter} ",
      query.merge({:action => :index, :letter => letter}))
    end
    return return_text + "|"
  end

  # create +/- link that will show/hide element defined in node_id
  #def hideable_link(node_id)
    #link_to("+/-", "#", :class => 'hideable', :rel => node_id)
  #end

  def filter_tag(group, label, options={})
    value   = options.delete(:value)
    value   = label unless value
    id      = "filters_#{ group }_#{ sanitize_to_id(value) }"
    title   = options.delete(:title)
    title   = title.html_safe if title.present?
    options = options.merge({:id => id})

    checked = if params[:filters] && params[:filters][group]
      params[:filters][group].include?(value.to_s)
    end

    html = []
    html << check_box_tag("filters[#{ group }][]", value, checked, options)
    html << label_tag(id, label, :title => title)
    html.join("\n").html_safe
  end

  def generate_markers_json(locations)
    locations.collect do |c|
      {
        :id => c.organization.id,
        :name => c.organization.name,
        :location_name => c.name,
        :address_line1 => c.address.line_1,
        :address_line2 => c.address.line_2,
        :city => c.address.city,
        :region => c.address.region,
        :postal_code => c.address.postal_code,
        :country => c.address.country,
        :logo => c.organization.logo_url(:mini),
        :accuracy => c.accuracy,
        :lat => c.lat,
        :lng => c.lng,
        :organization_type=>getOrganizationType(c.organization)
      }
    end.to_json
  end

  def marker_icon_url(opts={})
    opts[:letter] ||= 1
    opts[:bg_color] ||= '#ffffff'
    opts[:fg_color] ||= '#000000'
    opts[:bg_color] = opts[:bg_color].gsub("#", '')
    opts[:fg_color] = opts[:fg_color].gsub("#", '')
    "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{ opts[:letter] }|#{ opts[:bg_color] }|#{ opts[:fg_color] }"
  end

  def generate_connections_search_json(users)
    users.map do |user|
      avatar = user.avatar.exists? ? user.avatar.url(:mini) : "/images/avatar_mini.gif"

      {
        :label => user.full_name,
        :value => user.id,
        :avatar => avatar
      }
    end.to_json.html_safe
    #users.map {|user| user.full_name}.to_json
  end

  def generate_postal_code_search_json(postal_codes)
    postal_codes.collect do |c|
      {
        :code => c.code,
        :city => c.city,
        :region => c.region
      }
    end.to_json.html_safe
  end
  
  def generate_city_region_search_json(postal_codes)
    postal_codes.collect do |c|
      "%s (%s)" % [c.city, c.region]
    end.to_json.html_safe
  end
  
  def unclaimed_organization_information(organization)
    email = organization.aba_email || organization.syta_email
    if email.present?
      auto_link("#{organization.name} has not updated their iTourSmart profile yet. Click #{mail_to email, 'here', :subject => 'Question from ' + current_user.name + ' (from iTourSmart)', :body => ('I saw your profile on iTourSmart.com and had a question:          <ask question here>')} to send #{organization.name} an email with your question.".html_safe)
    else
      "#{organization.name} has not set up their iTourSmart account yet.  If you know them, invite them to explore iTourSmart"
    end
  end

  def url_for_checkbox_state(name, current_state)
    query = params.clone
    if current_state.to_i == 1
      #remove params
      query.delete(name)
    else
      query = query.merge(name => 1)
    end
    url_for(query)
  end
  
  # Detect if the action is claim.
  # Both will return edit even though the url is /organization/2/claim
  # controller.action_name.to_s
  # controller.params[:action]
  def request_action_is_claim?
    request.env['PATH_INFO'] =~ /\/claim$/
  end

  # JS Timestamps
  # = timeago(@organization.trial_ends_at)
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
    
end
