Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cocktails, only: %i[index show new create] do
    resources :doses, only: %i[new create]
    resources :reviews, only: %i[new create]
    collection do
      get 'search'
    end
  end
  resources :doses, only: %i[destroy]
end
