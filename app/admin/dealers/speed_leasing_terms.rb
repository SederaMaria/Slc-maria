ActiveAdmin.register_page 'Application Setting', namespace: :dealers do
  # menu label: 'Download Current Speed Leasing Terms', html_options: { class: 'menu-button' },
  #      url:   proc { CommonApplicationSetting.instance.decorate.file_url }, priority: 999, if: proc { CommonApplicationSetting.instance.decorate.has_company_term? }
end
