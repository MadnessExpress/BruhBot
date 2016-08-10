module Required

  class Auth
    def auth(rolesAdmin, rolesServer, rolesUser)
      roleId = []
      @adminUser = ""

      rolesAdmin.each do |role|
        roleId << rolesServer.find { |r| r.name == role }
      end

      roleId.each do |role|
        if (rolesUser.role?(role) == true)
          @adminUser = true
        else
          @adminUser = false
        end
      end
    end

    def adminuser
      @adminUser
    end
  end

  class Logger
    def logs(logType, userName, userId, message)
      time = Time.new
      logFile = time.strftime("%m-%d-%Y")
      logHeader = "Time  |  Username  |  User ID  |  Command\n\n"
      logString = "#{time.strftime("%I:%M:%S%p")}  |  #{userName}  |  #{userId}  |  #{message}\n"
      
      if (logType == "command")
        File.open("logs/commandlogs/#{logFile}.txt", "a") {|f| f.write(logHeader) } unless File.exists?("logs/commandlogs/#{logFile}.txt")
        File.open("logs/commandlogs/#{logFile}.txt", "a") {|f| f.write(logString) }
      elsif (logType == "message")
        File.open("logs/messagelogs/#{logFile}.txt", "a") {|f| f.write(logHeader) } unless File.exists?("logs/messagelogs/#{logFile}.txt")
        File.open("logs/messagelogs/#{logFile}.txt", "a") {|f| f.write(logString) }
      end
    end
  end
end
