# frozen_string_literal: true

if defined?(Bullet)
  <%= app_const %>.config.after_initialize do
    Bullet.enable = !Rails.env.production?
    Bullet.alert = false
    Bullet.bullet_logger = false
    Bullet.console = false
    Bullet.growl = false
    Bullet.rails_logger = true
    Bullet.raise = Rails.env.test?
  end
end
