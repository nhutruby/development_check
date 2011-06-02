class Ability
  include CanCan::Ability 

  def initialize(user)
    user ||= User.new #guest user
    if user.its_admin?
      can :manage, :all
    elsif user.id
      #User
        can :read, User
        can :manage, User, :id => user.id
      #General
      #can :read, [Announcement, Page] - removed during pre-beta walkthrough
      can :read, [Page]
      
      #Organization
      can :read, [Organization, Location, InventoryItem, InventoryItemLocation, Price, Asset]
      # admin actions
      cannot :list_by_accuracy, Location
      cannot :geocode, Location

      can :create, Organization
      can :manage, Organization, :roles => {:user_id => user.id, :is_admin => true, :is_organization_approved => true}
      #can :manage, Organization, :owner_id => user.id, :roles => {:user_id => user.id, :is_approved => true}
      can :manage, Organization, :owner_id => user.id
      can :manage, Organization, :owner_id => nil
      can :create, Location
      can :manage, Location, :roles => {:user_id => user.id, :is_admin => true, :is_organization_approved => true}
      
      
      can :create, Asset
      can :manage, Asset do |asset|
        asset.assetable.roles.any?{|r| r.user_id == user.id && r.is_admin == true} if asset.assetable
      end



      can :create, InventoryItem
      can :manage, InventoryItem, :roles => {:user_id => user.id, :is_admin => true, :is_organization_approved => true}


      # admin actions
      cannot :featured, Organization
      cannot :make_featured, Organization
      can :manage, Subscription, :owner_id => user.id, :roles => {:user_id => user.id}

      #Note
      can :create, Note
      can :manage, Note, :sender_id => user.id

      #Recipient
      can :create, Recipient
      can :read, Recipient, :user_id => user.id
      can :manage, Recipient, :user_id => user.id
      can :manage, Recipient, :is_read => false, :note => {:sender_id => user.id}
      
      #Connection
      can :read, Connection
      can :manage, Connection, :user_id => user.id
      can :manage, Connection, :connection_id => user.id
      
      can :manage, Membership

      #Role     
      can :read, Role, :user_id => user.id
      can :manage, Role, :team_members => {:user_id => user.id, :is_admin => true}
      can :manage, Role, :user_id => user.id

      #can :create, Note
      #can :manage, Note, :sender_id => user.id
      #can :create, Categorization
      
      can :search, PostalCode
      
    else
      can :read, Page

    end
  end
end