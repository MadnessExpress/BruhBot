#This is the BruhBot configuration file.

#Define a shutdown message below

def shutdownmessage()

  shutdownmessage = 'I am going to sleep now, goodnight!'

  return shutdownmessage

end

#Define plugins below

def plugins()

  #To disable a module simply comment out the a.push() for each unwanted module.

  #To add a new module simply add in the code a.push(x) and fill in the name, numbering, or lettering of your module where x is
  #and make sure it does not conflict with the naming of any other modules

  #This should create the empty modules array.
  plugins = Array.new

  #Tableflip
  plugins << Tableflip

  #Dice Roller
  plugins << Diceroller

  Reactions
  plugins << Reactions

  return plugins

end

