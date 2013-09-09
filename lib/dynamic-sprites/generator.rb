module DynamicSprites
  # Generates sprites
  #
  class Generator

    # Array of file extensions used for creating sprites.
    #
    VALID_EXTENSIONS = %w(.png .jpg .jpeg .gif .ico)

    # Initializer
    #
    # filename  - Pathname where generated file should be placed to.
    # path - Pathname of directory containing source images.
    # layout - sprite layout name as a String
    #
    def initialize(filename, path, layout)
      @filename = filename
      @layout = layout
      @files = Dir.glob(File.join(path, '*')).sort.select { |e| VALID_EXTENSIONS.include?(File.extname(e)) }
      @images = load(@files)
      @canvas = canvas
    end

    # Main method for sprites generation
    #
    def run!
      @canvas.opacity = Magick::MaxRGB
      offset_x = 0
      offset_y = 0
      @images.each do |image|
        @canvas.composite!(image[:image], offset_x, offset_y, Magick::SrcOverCompositeOp)
        if @layout == 'horizontal'
          offset_x += image[:width]
        else
          offset_y += image[:height]
        end
      end
      @canvas.write(@filename)
    end

    # Returns a call to sass mixin function with default attributes
    #
    def mixin_call
      call = "dynamic-sprite"
      call << "-horizontal" if @layout == "horizontal"
      arguments = [
        @filename,
        @files.map{ |f| File.basename(f) },
        "#{100 / (@files.size - 1)}%",
        "100%",
        "#{100 * @images.first[:height] / @images.first[:width]}%"
      ]
      call << "(#{arguments.join(', ')})"
    end

    private

    # Converts Array of Filenames into an Array of Magic::Image objects
    #
    def load(files)
      files.map do |filename|
        image = Magick::Image.read(filename)[0]
        {
          :image    => image,
          :width    => image.columns,
          :height   => image.rows
        }
      end
    end

    # Returns canvas on which images will be sequentially placed
    #
    def canvas
      images_width = @images.map{ |i| i[:width] }
      images_height = @images.map{ |i| i[:height] }
      if @layout == 'horizontal'
        width = images_width.reduce(:+)
        height = images_height.max
      else
        height = images_height.reduce(:+)
        width = images_width.max
      end
      Magick::Image.new(width, height)
    end
  end
end