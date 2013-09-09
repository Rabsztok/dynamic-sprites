module DynamicSprites
  class Runner

    attr :command
    attr :path
    attr :options
    attr :interface

    def initialize(command, path, options = {})
      @interface = Interface.new
      @command = command
      @path = Pathname.new(path) unless path.nil?
      @path ||= File.join(sass_directory, 'dynamic-sprites.sass') unless command.nil?
      @options = options
      @options[:output] ||= "#{@path}.png"
    end

    # Runs dynamic-sprites command.
    #
    def run!
      case command
      when 'init'
        generate_mixin!
      when 'generate'
        generate_sprite!
      end
    end

    private

    # Generates mixin in provided path or initializes user interface to determine it otherwise.
    #
    def generate_mixin!
      FileUtils.copy DynamicSprites.mixin_source_path, path
      interface.generate_mixin_summary(path)
    end

    # Generates sprite using provided options.
    #
    def generate_sprite!
      generator = Generator.new(options[:output], path, options[:layout])
      generator.run!
      interface.generate_sprite_summary(@options[:output], generator.mixin_call)
    end

    # Chooses one of possible options of defining sass directory path.
    #
    def sass_directory
      case sass_directories.size
      when 0
        interface.prompt_directory
      when 1
        sass_directories.first
      else
        interface.choose_directory(sass_directories)
      end
    end

    # Returns an Array of possible paths to directories of project .sass files.
    #
    def sass_directories
      style_directories = []
      Find.find(Dir.pwd) do |path|
        next unless FileTest.directory?(path)
        if File.basename(path).match /sass|style/
          style_directories << Pathname.new(path)
        elsif File.basename(path)[0] == ?.
          Find.prune
        else
          next
        end
      end
      style_directories
    end
  end
end