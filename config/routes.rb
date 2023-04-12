Rails.application.routes.draw do
  resources :cages
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :dinosaurs
  resources :cages do
    get 'dinosaurs', to: 'cages#dinosaurs'
  end

end
