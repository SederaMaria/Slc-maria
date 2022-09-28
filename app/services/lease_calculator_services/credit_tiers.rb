module LeaseCalculatorServices
  class CreditTiers
    class << self
      def retrieve
        LeaseCalculator.pluck('DISTINCT credit_tier').compact.sort! do |a, b|
          read_tier(a) <=> read_tier(b)
        end
      end

      private

      def read_tier(description)
        description.gsub('Tier ', '').split(' ').first.to_i
      end
    end
  end
end
