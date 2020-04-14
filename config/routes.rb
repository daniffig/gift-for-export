Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/gift-template.xlsx', to: 'application#download_template', as: :download_template
  get '/gift-example.xlsx', to: 'application#download_example', as: :download_example

  get '/', to: 'application#new', as: :new
  post '/', to: 'application#convert', as: :convert

  root 'application#new'
end
