require 'rails_helper'

RSpec.describe LeasePackageDocuments::SecondPaymentDate do
  let!(:year) { Date.current.year }
  let!(:month) { Date.current.month }
  subject { described_class }

  it "should return a default format of :date" do
    return_value = subject.calculate(Date.new(year, month, 15), :second_monthly_payment)
    standard_second_monthly_payment = Date.new(determine_year(Date.current), determine_month(Date.current), 15)

    expect(return_value).to be_a_kind_of(Date)
    expect(return_value).to eq(standard_second_monthly_payment)
  end
  context ":second_monthly_payment" do
    it "should return an ordinalized day when not on the 29th, 30th, or 31st" do
      aggregate_failures do
        (1..28).each do |day|
          return_value = subject.calculate(Date.new(year, 2, day), :second_monthly_payment, :day)
          expect(return_value).to eq(day.ordinalize)
        end
      end
    end

    it "should return a Date 30 days in the future when not on the 29th, 30th, or 31st" do
      aggregate_failures do
        (1..28).each do |day|
          original_date = Date.new(year, 2, day)
          return_value = subject.calculate(original_date, :second_monthly_payment, :date)
          expect(return_value).to eq(original_date + 1.month)
        end
      end
    end
  end

  context ":second_ach_split_pay" do

    it "should return the ordinalized day 15 days in the future" do
      (1..13).each do |day|
        second_payment_day = day + 15
        return_value = subject.calculate(Date.new(year, month, day), :second_ach_split_pay, :day)
        expect(return_value).to eq(second_payment_day.ordinalize)
      end
    end

    it "should return the ordinalized day 15 days in the future" do
      (18..31).each_with_index do |day, i|
        second_payment_days = (2..15).to_a
        return_value = subject.calculate(Date.new(determine_year( Date.current), 1, day), :second_ach_split_pay, :day)
        expect(return_value).to eq(second_payment_days[i].ordinalize)
      end
    end
  end

  def determine_month(date)
    date.month == 12 ? 1 : date.month + 1
  end

  def determine_year(date)
    date.month == 12 ? date.year + 1 : date.year
  end
end