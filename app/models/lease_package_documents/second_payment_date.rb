class LeasePackageDocuments::SecondPaymentDate

  attr_reader :date, :type, :format

  def self.calculate(date, type, format = :date)
    return if date.nil?
    self.new(date, type, format).evaluate
  end

  def initialize(date, type, format = :date)
    @date   ||= date.to_date
    @type   ||= type.to_sym
    @format ||= format.to_sym
  end

  def evaluate
    case @type
    when :second_monthly_payment
      format(second_monthly_payment_date)
    when :second_ach_split_pay
      format(second_ach_split_pay_date)
    end
  end

  def second_monthly_payment_date
    if (29..31).include? @date.day
      (@date + 1.months).change(day: 28)
    else
      (@date + 1.month)
    end
  end

  def second_ach_split_pay_date
    date = @date + 15.days
    if (29..31).include? date.day
      Date.new(determine_year, determine_month, 28)
    else
      date
    end
  end

  private

  def determine_year
    @date.month == 12 ? @date.year + 1 : @date.year
  end

  def determine_month
    @date.month == 12 ? 1 : @date.month + 1
  end


  def format(date)
    case @format
    when :date
      date
    when :day
      date.day.ordinalize
    end
  end
end