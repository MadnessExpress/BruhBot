require 'rmagick'
require 'open-uri'
require 'mp3info'
require 'youtube-dl.rb'
include Magick

class String
  def numeric?
    begin
      Integer(self)
    rescue
      false # not numeric
    else
      true # numeric
    end
  end
end

class Object
  def blank?
    if self.nil? || self.empty?
      true # no value or nil value
    else
      false # numeric
    end
  end
end

def reformat_wrapped(s, width)
  lines = []
  line = ''
  s.split(/\s+/).each do |word|
    if line.size + word.size >= width
      lines << line
      line = word
    elsif line.empty?
     line = word
    else
     line << ' ' << word
    end
   end
   lines << line if line
  return lines.join "\n"
end

def createSpoiler(text, text2, messageid)
  gc = Magick::Draw.new {
    self.stroke = 'transparent'
    self.font = 'helvetica'
    self.pointsize = 16
  }

  if text2.length >= text.length
    metrics = gc.get_multiline_type_metrics(text2)

    width = metrics.width + 40
    height = metrics.height
  elsif text.length > text2.length
    metrics = gc.get_multiline_type_metrics(text)

    width = metrics.width + 40
    height = metrics.height
  end

  spoiler = Magick::Image.new(width, height) {
    self.background_color = '#36393E'
  }

  spoilerText = Draw.new

  spoiler.annotate(spoilerText, 0,0,0,0, text){
    self.gravity = Magick::CenterGravity
    self.pointsize = 16
    self.fill = 'white'
  }

  spoiler2 = Magick::Image.new(width, height) {
    self.background_color = '#36393E'
  }

  spoilerText2 = Draw.new

  spoiler2.annotate(spoilerText2, 0,0,0,0, text2){
    self.gravity = Magick::NorthWestGravity
    self.pointsize = 16
    #txt.stroke = ‘#000000’
    self.fill = 'white'
  }

  gif = ImageList.new()
  gif << spoiler
  gif << spoiler2
  gif.iterations = 1
  gif.format = 'gif'
  gif.write("images/spoiler/#{messageid}.gif")
end

def manageMusic(server)
  music = "data/#{server}/music"
  if File.exists?(music)
    Dir.foreach(music) do |file|
      if ((file.to_s != ".") and (file.to_s != ".."))
        File.delete("#{music}/#{file}")
      end
    end
  elsif !File.exists?(music)
    FileUtils.mkpath music unless File.exist?(music)
  end
end

def addYoutube(server, message, url)
  options = {
    format: 'bestaudio',
    extract_audio: true,
    audio_format: 'mp3',
    output: "data/#{server}/music/#{message}.%(ext)s"
  }
  YoutubeDL.download url, options
end
