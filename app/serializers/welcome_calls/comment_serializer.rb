module WelcomeCalls
  class CommentSerializer < ApplicationSerializer
    attributes :id, :body, :author_id, :author_type, :created_at, :updated_at, :author_name

    def author_name
      self.object&.author.full_name
    end

    def created_at
      self.object&.created_at.strftime("%B %d, %Y %H:%M")
    end   
    
  end
end