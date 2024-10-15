Rails.application.routes.draw do
  resources :projects do
    member do
      get 'media'        # Get all media files for a project
      post 'add_media'   # Add media to an existing project
      delete 'remove_media/:media_id', to: 'projects#remove_media', as: 'remove_media'  # Remove specific media
    end
  end
end
