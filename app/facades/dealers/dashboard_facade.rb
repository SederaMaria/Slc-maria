module Dealers
  class DashboardFacade
    attr_reader :lease_apps

    def initialize(dealer: )
      apps = LeaseApplication.where(dealer: dealer)
      @lease_apps = LeaseApplicationDecorator.decorate_collection(apps)
    end
  end
end
