class GlobalSecurityDeposit
  
  def self.value(make, us_sate, credit_tier, dealership)
    unless dealership.nil?
      return dealership.security_deposit if dealership.enable_security_deposit
    end
    unless credit_tier.nil?
      return credit_tier.security_deposit if credit_tier.enable_security_deposit
    end
    unless us_sate.nil?
      return us_sate.security_deposit if us_sate.enable_security_deposit
    end
    return make.global_security_deposit if make.enable_global_security_deposit
    return 0
  end
  
  def self.enable_security_deposit(make, us_sate, credit_tier, dealership)
    unless dealership.nil?
      return true if dealership.enable_security_deposit
    end
    unless credit_tier.nil?
      return true if credit_tier.enable_security_deposit
    end
    unless us_sate.nil?
      return true if us_sate.enable_security_deposit
    end
    return true if make.enable_global_security_deposit
    return false
  end
  
end