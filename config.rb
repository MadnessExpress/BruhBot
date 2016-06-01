#This is the BruhBot configuration file.

#Define your command prefix below

def commandprefix()

  commandprefix = '!'

  return commandprefix

end

#Define a shutdown message below

def shutdownmessage()

  shutdownmessage = 'I am going to sleep now, goodnight!'

  return shutdownmessage

end

#Define Choice messages

def choicemessage()

  choicemessage = []

  choicemessage << "I choose #{$choice_choice}!"
  choicemessage << "I think #{$choice_choice} is awesome!!!!"

  return choicemessage

end

#Define 8ball outcomes below

def eightball()

  eightball = ['It is certain.', 'It is decidedly so.', 'Without a doubt.', 'Yes, definitely.', 'You may rely on it.',
           'As I see it, yes.', 'Most likely.', 'Outlook good.', 'Yes', 'Signs point to yes', 'Reply hazy try again',
           'Ask again later', 'Better not tell you now', 'Cannot predict now', 'Concentrate and ask again',
           'Don\'t count on it', 'My reply is no', 'My sources say no', 'Outlook not so good', 'Very doubtful'] 

  return eightball

end

#Define reaction images below

def smug()

  smug = ['http://i.imgur.com/3WeW7RK.png', 'http://i.imgur.com/waRuHXo.png', 'http://i.imgur.com/DShJUv2.png']

  return smug

end

#Define plugins below

def plugins()

  #To disable a module simply comment out the line that contains (plugins << module name) for each unwanted module.

  #To add a new module simply add in the code (plugins << Your Module Name) without the parentheses and fill in the 
  #name of your module and make sure it does not conflict with the naming of any other modules.

  #This should create the empty modules array.
  plugins = []

  #Tableflip
  plugins << Tableflip

  #Dice Roller
  plugins << Diceroller

  #Reactions
  plugins << Reactions

  #8ball
  plugins << Eightball

  #Rate: This allows users to rate stuff.
  plugins << Rate

  #Play: This allows users to notify groups that they want to play a game.
  plugins << Play

  #Choice: This allows you to have the bot choose something.
  plugins << Choice

  #Say: This makes the bot say stuff
  plugins << Say

  #Cleverbot
  plugins << CleverbotPlugin

  #Rps: This is the rock, paper, scissors plugin
  plugins << Rps

  return plugins

end
