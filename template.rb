gem 'action_args'
gem 'active_model_serializers', '~> 0.10.0.rc4'
gem 'autoprefixer-rails'
gem 'browserify-rails'
gem 'hiredis'
gem 'meta-tags'
gem 'oj'
gem 'oj_mimic_json'
gem 'rails-api'
gem 'rails-i18n'
gem 'redis', require: %w(redis redis/connection/hiredis)
gem 'redis-namespace'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'slim-rails'

gem_group :development, :test do
  gem 'bullet'
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'minitest-rails'
  gem 'minitest-spec-rails'
  gem 'quiet_assets'
end

gem_group :development do
  gem 'gem_sort'
  gem 'guard', require: false
  gem 'guard-bundler', require: false
  gem 'guard-minitest', require: false
  gem 'guard-process', require: false
  gem 'guard-rails', require: false
  gem 'guard-sidekiq', require: false
  gem 'letter_opener'
  gem 'overcommit', require: false
  gem 'parser', '~> 2.3'
  gem 'rubocop'
  gem 'slim_lint'
  gem 'terminal-notifier', require: false
  gem 'terminal-notifier-guard', require: false
end

gem_group :test do
  gem 'database_rewinder'
  gem 'ffaker'
  gem 'minitest-around'
  gem 'minitest-power_assert'
  gem 'simplecov', require: false
end

application <<-CODE
%w(
      app/jobs
      app/jobs/concerns
      app/serializers
    ).each do |path|
      config.autoload_paths << File.join(config.root, path)
      config.eager_load_paths << File.join(config.root, path)
    end

    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:ja, :en]
    config.i18n.fallbacks = [:ja, :en]
    config.i18n.default_locale = :ja

    config.active_record.raise_in_transactional_callbacks = true
    config.api_only = false
    config.active_job.queue_adapter = :sidekiq

    config.action_view.field_error_proc = proc { |html_tag, _instance|
      html_tag
    }

    config.generators do |g|
      g.helper false
      g.javascripts false
      g.stylesheets false
      g.template_engine :slim
      g.test_framework :minitest, spec: true, fixture: false
    end
CODE

environment <<-CODE, env: 'development'
config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_controller.asset_host = 'http://localhost:3000'
CODE

cwd = File.expand_path(File.dirname(__FILE__))
files_root = File.join(cwd, 'files')

Dir.glob(File.join(files_root, '**', '*'), File::FNM_DOTMATCH).each do |path|
  dest_path = path.sub("#{files_root}/", '')

  template path, dest_path, force: true
end

gemfile = File.read(File.join(destination_root, 'Gemfile'))
gemfile = gemfile.gsub(%r{\s*#.*$}, '').gsub(%r{\n+}, "\n")
file('Gemfile', gemfile, force: true)

unless options[:skip_git]
  append_to_file('.gitignore', '/node_modules')
  append_to_file('.gitignore', '.DS_Store')
  append_to_file('.gitignore', '/coverage')
end

file 'app/locales/.keep', ''
file 'app/serializers/.keep', ''
file 'app/jobs/.keep', ''

run 'rm app/views/layouts/application.html.erb'
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'

after_bundle do
  rake 'gem:sort'
  run 'bundle exec rubocop -a'
  run 'npm install'

  unless options[:skip_git]
    git :init
    run 'bundle exec overcommit --install'
    run 'bundle exec overcommit --sign'

    if yes?("Create first commit?")
      git add: "."
      git commit: %(-m "Init project")
    end
  end
end
