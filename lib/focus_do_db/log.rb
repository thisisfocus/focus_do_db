require 'paint'

module FocusDoDb
  class Log
    def self.print(str)
      puts Paint[" %-80s " % str, "#000000", "#ffc0cb"]
    end
  end
end
