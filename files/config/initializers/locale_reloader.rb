# frozen_string_literal: true
if Rails.env.development?
  class <%= app_const_base %>::LocaleReloader
    def initialize(app)
      @app = app
    end

    def call(env)
      I18n.load_path += Dir[Rails.root.join('app', 'locales', '**', '*.{rb,yml}').to_s]
      I18n.load_path.uniq!
      I18n.backend.reload!

      @app.call(env)
    end
  end

  Rails.application.config.middleware.use(<%= app_const_base %>::LocaleReloader)
end
