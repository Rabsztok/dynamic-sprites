require File.expand_path('test_case', File.dirname(__FILE__))

module DynamicSprites
  class RunnerTest < DynamicSprites::TestCase

    def test_init_command_integration
      with_clean_output do
        path = temporary_path('mixin.sass')
        DynamicSprites.run!('init', path)
        assert(File.exist?(path), "Generated mixin does not exist")
        assert(FileUtils.compare_file(path, DynamicSprites.mixin_source_path), "Failed trying to generate mixin")
      end
    end

    def test_generate_command_integration
      with_clean_output do
        images_path = Pathname.new(reference_path('images'))

        path = temporary_path('sprite-vertical.png')
        DynamicSprites.run!('generate', images_path, { output: path })
        assert(File.exist?(path), "Generated sprite does not exist")
        assert(FileUtils.compare_file(path, reference_path('sprite-vertical.png')), "Failed trying to generate sprite")

        path = temporary_path('sprite-horizontal.png')
        DynamicSprites.run!('generate', images_path, { output: path, layout: 'horizontal' })
        assert(File.exist?(path), "Generated horizontal sprite does not exist")
        assert(FileUtils.compare_file(path, reference_path('sprite-horizontal.png')), "Failed trying to generate horizontal sprite")
      end
    end

  end
end