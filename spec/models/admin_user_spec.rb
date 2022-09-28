# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_changed_at    :datetime
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  is_active              :boolean          default(TRUE)
#  job_title              :string
#  security_role          :string
#  auth_token             :string
#  auth_token_created_at  :datetime
#  security_role_id       :bigint(8)
#  unique_session_id      :string(20)
#  last_request_at        :datetime
#
# Indexes
#
#  index_admin_users_on_auth_token_and_auth_token_created_at  (auth_token,auth_token_created_at)
#  index_admin_users_on_email                                 (email) UNIQUE
#  index_admin_users_on_password_changed_at                   (password_changed_at)
#  index_admin_users_on_reset_password_token                  (reset_password_token) UNIQUE
#  index_admin_users_on_security_role_id                      (security_role_id)
#
# Foreign Keys
#
#  fk_rails_...  (security_role_id => security_roles.id)
#

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "validations" do
    describe "passwords" do
      #it "should require a lowercase letter character" do
      #  resource = described_class.new(password: 'ABCD123!')
      #  expect(resource).to eq(1).error_on(:password)
      #end

      context "good passwords with special characters" do
        it "knows a good password when it sees one !" do
          resource = described_class.new(password: 'AbCd1234!', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one @" do
          resource = described_class.new(password: 'AbCd1234@', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one #" do
          resource = described_class.new(password: 'AbCd1234#', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one $" do
          resource = described_class.new(password: 'AbCd1234$', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one %" do
          resource = described_class.new(password: 'AbCd1234%', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ^" do
          resource = described_class.new(password: 'AbCd1234^', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one &" do
          resource = described_class.new(password: 'AbCd1234&', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one *" do
          resource = described_class.new(password: 'AbCd1234*', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one (" do
          resource = described_class.new(password: 'AbCd1234(', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one )" do
          resource = described_class.new(password: 'AbCd1234)', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one -" do
          resource = described_class.new(password: 'AbCd1234-', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one _" do
          resource = described_class.new(password: 'AbCd1234_', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one +" do
          resource = described_class.new(password: 'AbCd1234+', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one =" do
          resource = described_class.new(password: 'AbCd1234=', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one [" do
          resource = described_class.new(password: 'AbCd1234[', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ]" do
          resource = described_class.new(password: 'AbCd1234]', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one {" do
          resource = described_class.new(password: 'AbCd1234{', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one }" do
          resource = described_class.new(password: 'AbCd1234}', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ," do
          resource = described_class.new(password: 'AbCd1234,', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ." do
          resource = described_class.new(password: 'AbCd1234.', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one /" do
          resource = described_class.new(password: 'AbCd1234/', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ?" do
          resource = described_class.new(password: 'AbCd1234?', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one <" do
          resource = described_class.new(password: 'AbCd1234<', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one >" do
          resource = described_class.new(password: 'AbCd1234>', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one :" do
          resource = described_class.new(password: 'AbCd1234:', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ;" do
          resource = described_class.new(password: 'AbCd1234;', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one |" do
          resource = described_class.new(password: 'AbCd1234|', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one \\" do
          resource = described_class.new(password: 'AbCd1234\\', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one `" do
          resource = described_class.new(password: 'AbCd1234`', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one ~" do
          resource = described_class.new(password: 'AbCd1234~', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one \'" do
          resource = described_class.new(password: 'AbCd1234\'', email: 'bob@example.com')
          expect(resource).to be_valid
        end
        it "knows a good password when it sees one \"" do
          resource = described_class.new(password: 'AbCd1234"', email: 'bob@example.com')
          expect(resource).to be_valid
        end
      end
    end
  end
end
