OptimalCourseScheduler::Application.routes.draw do

  get "schools(.:format)" => "school#index"
  get "school(.:format)" => "school#index"
  get "school/:name(.:format)" => "school#show"
  get "school/:school_name/:name(.:format)" => "course#show"
  get "school/:school_name/:course_name/:name(.:format)" => "section#show"

  resources :schedules do 
    resources :schedule_course
    resources :time_constraint
    member do
      get "do_schedule"
    end
  end

  devise_for :users
  get "meeting/show"
  get "section/show"
  get "courses" => "course#index"
  get "main/index"
  get "main/about"
  get "main/test"

  resources :course
  resources :section
  resources :meeting

  root 'school#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
