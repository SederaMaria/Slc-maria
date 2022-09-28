module ActiveAdmin
  module Views
    class Footer < Component

      def build (namespace)
        super :id => "footer"                                                    
        super :style => "text-align: left;"                                     
        bactive = !Banner.all.empty? ? Banner.first.active : false
        bheadline = !Banner.all.empty? ? Banner.first.headline : ''
        bmessage = !Banner.all.empty? ? Banner.first.message : ''
        can_see = true
        can_see = current_dealer&.dealership&.can_see_banner if !current_dealer.nil?
        div "id" => "footer_banner_info", "data-can-see"=>"#{can_see}", "is-dealer" => "#{!current_dealer.nil?}", "data-bactive" => "#{bactive}","data-bheadline" => "#{bheadline}","data-bmessage" => "#{bmessage}", "data-bimage" => "#{asset_path("red-harley.png")}" do                                                                   
          small "Powered by "
          a "href" => "https://activeadmin.info" do 
              "Active Admin" 
          end
          small ActiveAdmin::VERSION                                       
        end
      end

    end
  end
end