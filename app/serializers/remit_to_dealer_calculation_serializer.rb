class RemitToDealerCalculationSerializer < ApplicationSerializer
    attributes :id, :calculation_name, :option_value, :option_label

    def option_value
        object&.id
    end

    def option_label
        object&.calculation_name
    end

end