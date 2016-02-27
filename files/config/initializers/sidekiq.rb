# frozen_string_literal: true
redis_url = ENV['REDIS_URL'] || ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379/'

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: "<%= app_name.underscore %>-#{Rails.env}" }

  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(Rails.root.join('config/schedule.yml')) || {})
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: "<%= app_name.underscore %>-#{Rails.env}" }
end
