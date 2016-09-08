require 'easy_translate'
require 'byebug'

class Mobile
  attr :file, :properties

  #Takes a file and loads the properties in that file
  def initialize file
    EasyTranslate.api_key = 'AIzaSyDrbD0AfKHiMZTYoite-ec4byLNlPxoX8k'
    @file = file
    @properties = []
    
    File.open(file, "r:UTF-8").each do |line| 
      @properties << line 
    end
  end
  
  #Helpfull to string
  def to_s
    output = "File Name #{@file} \n"
    @properties.each {|value| output += " #{value}" }
    output
  end

  def translate
    @translated = []
    @properties.each do |value|
      @translated << value
      if value.include? "1:"
        splited_value = value.encode!('UTF-8').split(':')
        to_translate = splited_value[1].strip
        @translated << splited_value[0].gsub("1","2") + ":" + EasyTranslate.translate(to_translate, :from => :pt, :to => :es) + "\n"
      end
    end
  end
  
  #Write a property
  def write_property (key,value)
    @properties[key] = value
  end
  
  #Save the properties back to file
  def save filename
    File.open(filename, 'w') { |file| @translated.each {|value| file.write("#{value}") } }  
  end

  def extractInterpolationPlaceholder translate
    i = 0
    while !translate.index(/{{[a-z]}}/).nil? do
       interpolation = translate[/{{[a-z]}}/]
       translate = translate.gsub(/{{[a-z]}}/, "$#{i}")
    end
  end
  
end
["alert.tl","appointment.tl","authentication.tl","case.tl","contact.tl","document.tl","event.tl",
  "helper.tl","historical.tl","priority.tl","sync.tl","tag.tl","tags.tl","task.tl"].each do |file|
  java = Mobile.new("in/#{file}")
  puts "#{file}"
  java.translate
  java.save("#{file}")
end
