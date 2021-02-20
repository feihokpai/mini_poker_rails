Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "game#index" 

  # get "enter_game", to: "game#enter"

  post "send_file", to: "game#send_file"

  post "process_file", to: "game#process_file"
end
