namespace :update_security_role do
  desc 'Update Security Roles'
  task update: :environment do
    admin_users.each do |user|
      if AdminUser.exists?(user[:id])
        AdminUser.find(user[:id]).update_column(:security_role, user[:security_role])
      end
    end
  end
  
  def admin_users
    [
      { id: 30, security_role:	"Underwriting User"},
      { id: 12, security_role:	"Underwriting User"},
      { id: 18, security_role:	"Underwriting User"},
      { id: 19, security_role:	"Underwriting User"},
      { id: 23, security_role:	"Underwriting User"},
      { id: 36, security_role:	"Administrator"},
      { id: 7, security_role:	"Underwriting User"},
      { id: 31, security_role:	"Underwriting User"},
      { id: 33, security_role:	"Underwriting User"},
      { id: 25, security_role:	"Underwriting User"},
      { id: 10, security_role:	"Underwriting User"},
      { id: 48, security_role:	"Underwriting User"},
      { id: 15, security_role:	"Underwriting User"},
      { id: 4, security_role:	"Underwriting User"},
      { id: 11, security_role:	"Underwriting User"},
      { id: 26, security_role:	"Underwriting User"},
      { id: 16, security_role:	"Underwriting User"},
      { id: 34, security_role:	"Underwriting User"},
      { id: 37, security_role:	"Underwriting User"},
      { id: 29, security_role:	"Underwriting User"},
      { id: 49, security_role:	"Underwriting User"},
      { id: 52, security_role:	"Underwriting User"},
      { id: 45, security_role:	"Underwriting User"},
      { id: 50, security_role:	"Underwriting User"},
      { id: 55, security_role:	"Underwriting User"},
      { id: 54, security_role:	"Underwriting User"},
      { id: 51, security_role:	"Underwriting User"},
      { id: 41, security_role:	"Underwriting User"},
      { id: 38, security_role:	"Underwriting User"},
      { id: 5, security_role:	"Underwriting User"},
      { id: 39, security_role:	"Underwriting User"},
      { id: 24, security_role:	"Underwriting User"},
      { id: 56, security_role:	"Underwriting User"},
      { id: 28, security_role:	"Underwriting User"},
      { id: 47, security_role:	"Underwriting User"},
      { id: 9, security_role:	"Underwriting User"},
      { id: 43, security_role:	"Underwriting User"},
      { id: 53, security_role:	"Underwriting User"},
      { id: 35, security_role:	"Underwriting User"},
      { id: 89, security_role:	"Underwriting User"},
      { id: 40, security_role:	"Administrator"},
      { id: 98, security_role:	"Underwriting User"},
      { id: 46, security_role:	"Underwriting User"},
      { id: 13, security_role:	"Underwriting User"},
      { id: 17, security_role:	"Underwriting User"},
      { id: 14, security_role:	"Underwriting User"},
      { id: 8, security_role:	"Underwriting User"},
      { id: 32, security_role:	"Underwriting User"},
      { id: 42, security_role:	"Underwriting User"},
      { id: 22, security_role:	"Underwriting User"},
      { id: 3, security_role:	"Administrator"},
      { id: 20, security_role:	"Underwriting User"},
      { id: 27, security_role:	"Underwriting User"},
      { id: 21, security_role:	"Underwriting User"},
      { id: 44, security_role:	"Underwriting User"},
      { id: 2, security_role:	"Underwriting User"}    
    ]
  end
  
end
