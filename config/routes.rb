MaripostaCore::Engine.routes.draw do
  scope module: 'mariposta' do
    resources :deployments

    get '/publish/review'
    post '/publish/now'

    get 'images' => 'images#index'
  end
end
