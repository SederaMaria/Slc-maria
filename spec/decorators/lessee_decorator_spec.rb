require 'rails_helper'

RSpec.describe LesseeDecorator do
  describe '#display_name' do
    let(:lessee) { build :lessee }
    subject { lessee.decorate.display_name }

    context 'when lessee is present' do
      let(:first_name) { lessee.first_name }
      let(:last_name) { lessee.last_name }
      let(:middle_name) { lessee.middle_name }
      let(:middle_initial) { "#{middle_name.chr}." }

      context 'when lessee has a middle name' do
        let(:expected_name) { "#{first_name} #{middle_name} #{last_name}" }

        it { is_expected.to eq(expected_name) }
      end

      context 'when lessee has a middle name with one letter' do
        before { lessee.update(middle_name: middle_name.chr) }

        let(:expected_name) { "#{first_name} #{middle_initial} #{last_name}" }

        it { is_expected.to eq(expected_name) }
      end

      context 'when lessee does not have a middle name' do
        before { lessee.update(middle_name: nil) }
        let(:expected_name) { "#{first_name} #{last_name}" }

        it { is_expected.to eq(expected_name) }
      end
    end
  end
end
