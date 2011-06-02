ITourSmart::Application.routes.draw do

  root :to => 'pages#splash'
  #comment out the line below to temporarily allow signup
  #match "users/sign_up" =>'pages#splash'

  match "zendesk/login" => "zendesk#login" # will match /zendesk/login
  match "zendesk/logout" => "zendesk#logout" # will match /zendesk/logout
  
  devise_for :users#, :controllers => {:sessions => 'sessions', :registrations => 'registrations', :confirmations => 'confirmations', :passwords => :passwords, :invitations => "invitations"}
  match "users/vcard/:id" => "vcards#show", :as => :vcard
  match "postal_code/search/:country_code" => "postal_codes#search", :as => :search_postal_code
  match "postal_code/search_city_region" => "postal_codes#search_city_region", :as => :search_city_region
  match "dmo_index" => "organizations#dmo_index"
  
  get "locations/list_by_accuracy" => "locations#list_by_accuracy", :as => :list_by_accuracy_locations
  get "locations/geocode" => "locations#geocode", :as => :geocode_locations
  
  #match ':controller/:action.:format'

  resources :assets
  resources :marker_colors
  resources :account_types

  match 'javascripts/hide_announcement' => 'javascripts#hide_announcement', :as => :hide_announcement

  match 'pages/tweets' => 'pages#tweets'
  match 'chargify/update_subscription' => 'chargify#update_subscription'
  match '/maps' => 'maps#index'
  match '/maps/locate' => 'maps#locate'

  match 'dashboard' => 'users#dashboard'
  
  resources :roles do
    member do
      post 'remove_from_organization', :action => :remove_from_organization
      get 'org_approve', :action => :organization_approve
      get 'org_decline', :action => :organization_decline
      put 'org_approve', :action => :organization_approve
      put 'org_decline', :action => :organization_decline
      put 'user_approve', :action => :user_approve
      put 'user_decline'
      get 'unset_admin'
      get 'set_admin'
    end
    collection do
      put 'update_multiple'
      post 'add_to_organization', :action => :add_to_organization
      put 'add_to_organization_unapproved', :action => :add_to_organization_unapproved
    end
  end
  
  resources :recipients do
    member do
      get 'fancybox_show'
    end
    collection do
      put 'mark_as'
    end
  end

  #  resources :connections
  resources :connections do
    get 'find_connections', :on => :collection
    post 'find_connections', :on => :collection
    post 'update_conection', :on => :collection
    get 'list_connections', :on => :collection
    collection do
      get 'inner_circle'
      get 'requested'
    end
  end
  
  resources :memberships do
    member do
      post 'mark', :action => :mark
    end
  end

  resources :account_types
  resources :announcements
  resources :attachments
  resources :categories
  resources :connections
  resources :notes
  resources :organizations do
    collection do
      get 'featured'
      get 'update_category_select/:id', :action => :update_category_select
      get 'list_by_trial'
    end
    member do
      post 'new'
      put 'account/update', :action => :update_account_admin
      post 'mark_as_closed', :action => :mark_as_closed
      post 'unmark_as_closed', :action => :unmark_as_closed
      post 'designate_as_member', :action => :designate_as_member
      post 'undesignate_as_member', :action => :undesignate_as_member
      post 'make_featured', :action => :make_featured
      #get 'merge_edit'
      #put 'merge_update', :action => :merge_update
      get 'update_category_select', :action => :update_category_select
      get 'cancel'
      put 'unclaim'
      get 'claim', :action => :edit
      get 'transactions'
      get 'subscriptions'
      put 'migrate'
      get 'change_card'
      put 'update_card'
      get 'signup'
      get 'upgrade'
    end




    resources :inventory_items do
      member do
      end
    end

    resources :locations do
      member do
      end
    end
  end

  resources :pages


  resources :users do
    member do
      get 'dashboard'
      get 'edit_email_preferences'
    end
  end

  scope 'blog' do
    resources :posts, :controller => 'blog_posts', :as => 'blog_posts' do
      resources :comments, :controller => 'blog_comments', :as => 'blog_comments'
      resources :images, :controller =>'blog_images', :as => 'blog_images'
      collection do
        get :drafts
      end
      member do
        get :tag
      end
    end
  end
  match 'blog' => 'blog_posts#index'

  match ':permalink' => 'pages#show'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end