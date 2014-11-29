module Actors
  module Customer
    module UseCases
      
      def self.register_for_an_account(user, email, password)
        user.email = email  
        user.password = password
        user.save!
      end      
      
    end
  end
end
