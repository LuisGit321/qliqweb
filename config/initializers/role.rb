ROLES = Role.all.collect(&:name) if Role.table_exists?

SYSTEM_ADMIN = 0 
GROUP_ADMIN = 1 
BILLING_ADMIN = 2
BILLING_FUNCTIONAL = 3
PHYSICIAN_ADMIN = 4
PHYSICIAN_FUNCTIONAL = 5

MONTH = [1,2,3,4,5,6,7,8,9,10,11,12] 
YEAR =  [2011,2012,2013,2014,2015,2016]
module Devise
  module Encryptors
    class Md5 < Base
      def self.digest(password, stretches, salt, pepper)
#        str = [password, salt].flatten.compact.join
         str = password
        Digest::MD5.hexdigest(str)
      end
    end
  end
end
