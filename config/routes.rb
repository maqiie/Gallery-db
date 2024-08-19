Rails.application.routes.draw do
  resources :projects do
    member do
      get 'media'
    end
  end
end
