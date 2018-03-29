MaripostaCore::Engine.routes.draw do
  scope module: 'mariposta' do
    resources :deployments
  end
end
