if ENV['RAILS_ENV'] == 'coverage'
  require 'simplecov'
  SimpleCov.start
end

require 'test/unit'
require 'pathname'
require 'rmagick'
require 'stringio'

require_relative '../lib/dynamic-sprites'

module DynamicSprites
  class TestCase < Test::Unit::TestCase

    attr :input
    attr :output

    def setup
      @input = StringIO.new
      @output = StringIO.new
    end

    #----------------------------------------------------------------------------

    REFERENCE_PATH    = 'test/reference'
    TEMPORARY_PATH    = 'test/temporary'

    def reference_path(file)
      Pathname.new(File.join(REFERENCE_PATH, file))
    end

    def temporary_path(file)
      Pathname.new(File.join(TEMPORARY_PATH, file))
    end

    #----------------------------------------------------------------------------

    def integration_test(command, path, options = {})
      output = options[:output] || path
      with_clean_output do
        DynamicSprites.run!(command, path, options)
        assert_reference_image(File.basename(output) + "." + (:png).to_s)
      end
    end

    #----------------------------------------------------------------------------

    def with_clean_output
      begin
        clean_output
        yield
      ensure
        clean_output
      end
    end

    def clean_output
      FileUtils.rm_rf(Dir.glob('test/temporary/*'))
    end

    #----------------------------------------------------------------------------

    def assert_runtime_error(msg = nil)
      e = assert_raise RuntimeError do
        yield
      end
      assert_match(msg, e.message) if msg
    end

    def assert_not_implemented(msg = nil)
      e = assert_raise NotImplementedError do
        yield
      end
      assert_match(msg, e.message) if msg
    end

    #----------------------------------------------------------------------------

    def assert_reference_image(name)
      #
      # images generated with different libraries (or different versions of same library)
      # might have different headers, so use rmagick to actually compare image bytes
      #
      actual         = output_path(name)
      expected       = reference_path(name)
      actual_image   = Magick::Image.read(actual)[0]
      expected_image = Magick::Image.read(expected)[0]
      img, val       = expected_image.compare_channel(actual_image, Magick::MeanAbsoluteErrorMetric)
      assert_equal(0.0, val, "generated image does not match pregenerated reference:\n actual:   #{actual}\n expected: #{expected}")
    end

    def assert_reference_style(name)
      actual   = output_path(name)
      expected = reference_path(name)
      diff = `cmp #{expected} #{actual}`
      assert(diff.empty?, "generated styles do not match pregenerated reference:\n#{diff}")
    end

    #----------------------------------------------------------------------------

  end # class TestCase
end # module SpriteFactory


#==============================================================================

class Class

  # allow tests to call private methods without ugly #send syntax
  def publicize_methods
    methods = private_instance_methods
    send(:public, *methods)
    yield
    send(:private, *methods)
  end

end

#==============================================================================