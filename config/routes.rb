MaripostaCore::Engine.routes.draw do
  scope module: 'mariposta' do
    resources :deployments

    get '/publish/review'
    post '/publish/now'

    get 'images' => 'images#index'

    get '/awesome/token'
    get '/awesome' => 'awesome#show'
    post '/awesome' => 'awesome#create'
  end
end
