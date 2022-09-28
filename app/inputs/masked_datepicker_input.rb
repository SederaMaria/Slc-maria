class MaskedDatepickerInput < Formtastic::Inputs::DatePickerInput
  def extra_input_html_options
    {
      data: {
        mask: '99/99/9999',
        datepicker_options: { dateFormat: "mm/dd/yy" }
      },
      class: 'datepicker'
    }
  end
end