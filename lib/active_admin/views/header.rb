module ActiveAdmin
  module Views
    class Header < Component
        def build(namespace, menu)
            super(id: "header")

            #add a class hide wich diplay none on the menu
            if params['embedded'] == 'true'
                super(class: "hide")
            end
            @namespace = namespace
            @menu = menu
            @utility_menu = @namespace.fetch_menu(:utility_navigation)

            build_site_title
            build_global_navigation
            build_utility_navigation
            end


            def build_site_title
                insert_tag view_factory.site_title, @namespace
            end

            def build_global_navigation
                #do not insert tag if params embedded is true
                insert_tag view_factory.global_navigation, @menu, class: 'header-item tabs' unless params['embedded'] == 'true'
            end

            def build_utility_navigation
                render partial: 'notifications' if @namespace.name == :admins
                insert_tag view_factory.utility_navigation, @utility_menu, id: "utility_nav", class: 'header-item tabs'
            end
        end
    end
end