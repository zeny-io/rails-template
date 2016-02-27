# frozen_string_literal: true
<%= app_const %>.config.tap do |config|
  config.browserify_rails.paths << Rails.root.join('app/assets/javascripts').to_s
  config.browserify_rails.source_map_environments << 'development'
  config.browserify_rails.commandline_options = '--fast -t babelify --extension=".js"'
  config.browserify_rails.evaluate_node_modules = Rails.env.development?
end
