module Required

  class Auth

    def auth(adminroles, serverroles, userroles)

      userroleid = []

      @adminuser = ""

      adminroles.each do |role|

        userroleid << serverroles.find { |r| r.name == role }

      end

      userroleid.each do |role|

        if (userroles.role?(role) == true)

          @adminuser = true

        else

          @adminuser = false

        end

      end

    end

    def adminuser

      @adminuser
 
    end

  end

end
