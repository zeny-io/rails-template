module ApplicationHelper
  def default_meta_tags
    {
      site: t('site.name'),
      description: I18n.exists?('site.description') ? t('site.description') : nil,
      title: t('.title', cascade: true),
      reverse: true,
      separator: '-',
      og: {
        type: t('.og.type', cascade: true, default: 'website'),
        title: :title
      },
      twitter: {
        type: t('.twitter.type', cascade: true, default: 'summary'),
        title: :title,
        description: :description
      }
    }
  end
end
