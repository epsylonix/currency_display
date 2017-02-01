Rails.application.routes.draw do

  controller :currencies do
    get   '/'      => :index, :as => :currencies
    get   '/admin(/:code)' => :edit, :as => :edit_currency
    patch '/admin(/:code)' => :update, :as => :update_currency
  end 

end
