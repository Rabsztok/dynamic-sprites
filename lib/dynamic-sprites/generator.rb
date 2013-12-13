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
    def initialize(filename, path, layout, geometry)
      @filename = filename
      @layout = layout
      @files = Dir.glob(File.join(path, '*')).sort.select { |e| VALID_EXTENSIONS.include?(File.extname(e)) }
      @images = Magick::ImageList.new(*@files)
      @geometry = Magick::Geometry.from_s(geometry) rescue default_geometry
    end

    # Main method for sprites generation
    #
    def run!
      # @canvas.opacity = Magick::MaxRGB
      geometry = @geometry
      tile = grid
      @images.montage do |c|
        c.geometry = geometry if geometry
        c.background_color = 'transparent'
        c.tile = tile
      end.write(@filename)
    end

    # Returns a call to sass mixin function with default attributes
    #
    def mixin_call
      call = "img.sprite\n  @include dynamic-sprite"
      call << "-horizontal" if @layout == "horizontal"
      arguments = [
        @filename.inspect,
        classess,
        "#{100.0 / (@images.length - 1)}%",
        "100%",
        "#{100.0 * @geometry.height / @geometry.width}%"
      ]
      call << "(#{arguments.join(', ')})"
    end

    private

    def grid
      if @layout == 'horizontal'
        Magick::Geometry.new(@images.length, 1)
      else
        Magick::Geometry.new(1, @images.length)
      end
    end

    # Changes array of files into String containing classes derived from file names.
    #
    def classess
      '(' + @files.map{ |f| File.basename(f).split('.').first.inspect }.join(', ') + ')'
    end

    def default_geometry
      Magick::Geometry.new(@images.first.columns, @images.first.rows)
    end
  end
end