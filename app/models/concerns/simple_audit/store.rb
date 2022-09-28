module SimpleAudit
  class Store
    def self.cache
      Thread.current[:audited_store] ||= {}
    end

    def self.auditor
      cache[:auditor]
    end
  end
end