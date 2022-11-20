Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # telegram_webhook Telegram::WebhookController

  defaults format: :json do
    resource :bot, only: %i[create]
  end

  root to: 'admin/dashboard#index'
end
