module DynamicSprites
  # User Interaction class
  #
  class Interface

    def prompt_directory
      puts "Where should sass mixin be placed? (e.g. '/home/User/project/app/assets/stylesheets')"
      prompt
    end

    def choose_directory(directories)
      puts "Found more than one possible sass directory. To which one you want to insert sass mixin?"
      option_number = 1
      directories.each do |directory|
        puts "#{option_number}. #{directory}"
        option_number += 1
      end
      puts "#{option_number}. Other"
      choice = choose(option_number)
      if choice == option_number
        puts "Enter directory path: (e.g. '/home/User/project/app/assets/stylesheets')"
        prompt
      else
        directories[choice.to_i - 1]
      end
    end

    def generate_mixin_summary(path)
      puts "Mixin generated in #{path}"
    end

    def generate_sprite_summary(path, mixin_call)
      puts "Sprite generated in #{path}"
      puts "\nYou can use it by calling this code in your sass document:"
      puts mixin_call
    end

    private

    # Choose option by it's index
    #
    def choose(limit)
      puts "Select an option (1-#{limit}):"
      choice = gets.to_i
      raise RangeError unless choice.between?(1, limit)
      choice
    rescue RangeError
      puts "Choose correct option (e.g. 1):"
      retry
    end

    # Prompt user for specific Pathname
    #
    def prompt
      path = gets
      raise FileNotFoundError unless File.exist?(path)
      Pathname.new(path)
    rescue FileNotFoundError
      puts "This path does not exist, try again:"
      retry
    end
  end
end

class FileNotFoundError < StandardError
end