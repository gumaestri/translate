require 'easy_translate'
require 'byebug'

class JavaProps
  attr :file, :properties

  #Takes a file and loads the properties in that file
  def initialize file
    EasyTranslate.api_key = 'AIzaSyDrbD0AfKHiMZTYoite-ec4byLNlPxoX8k'
    @file = file
    @properties = {}
    
    File.open(file, "r:UTF-8").each do |line| 
      if line.include? ":"
        splited_line = line.encode!('UTF-8').strip.split(':')
        @properties[splited_line[0]] = splited_line[1] 
      end 
    end
  end
  
  #Helpfull to string
  def to_s
    output = "File Name #{@file} \n"
    @properties.each {|key,value| output += " #{key}: #{value} \n" }
    output
  end

  def translate
    @properties.each do |key,value|
      if value.include? "@@"
        to_translate = value.delete("@@")
        @properties[key] = EasyTranslate.translate(to_translate, :from => :pt, :to => :es)
      end
    end
  end
  
  #Write a property
  def write_property (key,value)
    @properties[key] = value
  end
  
  #Save the properties back to file
  def save filename
    File.open(filename, 'w') { |file| @properties.each {|key,value| file.write("#{key}:#{value},\n") } }  
  end
  
end

java = JavaProps.new("in/translate.js")
puts java.to_s
java.translate
puts java.to_s
java.save("translated.js")
