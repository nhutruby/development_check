require "vpim/vcard"

class VcardsController < ApplicationController
skip_authorization_check
  def show
    @user = User.find(params[:id])
    
    card = Vpim::Vcard::Maker.make2 do |maker|

      maker.add_name do |name|
    	  name.prefix = ''
    	  name.given = @user.name_first
    	  name.family = @user.name_last
      end
      
      maker.title = ''
      
      #for address in @user.addresses do
        #maker.add_addr do |addr|
     	    #addr.location = address.location
     	    #addr.street = address.street
     	    #addr.locality = address.city
          #addr.zipcode = @user.addresses.first.postal_code
        #end
      #end

      for phone in @user.contact_methods.phone do
        maker.add_tel(phone.address) { |t| t.location = phone.lokation}
      end
      
      for email in @user.contact_methods.email do
        maker.add_email(email.address) { |e| e.location = email.lokation}
      end
      
      for url in @user.contact_methods.website do
        maker.add_url(url.url)
      end

    end
    send_data card.to_s, :filename => @user.name + ".vcf"
    #@card = card
  end
end
