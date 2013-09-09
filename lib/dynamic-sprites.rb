module DynamicSprites

  #----------------------------------------------------------------------------

  VERSION     = "0.0.3"
  SUMMARY     = "Responsive sprites - SASS mixin and sprite generator"
  DESCRIPTION = "Generates sass mixin and combines directory of images into one sprite"

  require 'find'
  require 'rmagick'

  require_relative 'dynamic-sprites/runner'  # Controller of this module
  require_relative 'dynamic-sprites/interface'  # User interaction methods
  require_relative 'dynamic-sprites/generator'  # Sprite generator

  # Initilizes Runner which controls all the magic stuff.
  #
  def self.run!(command, path, options = {})
    Runner.new(command, path, options).run!
  end

  private

  def self.gem_root
    File.expand_path '../..', __FILE__
  end

  def self.mixin_source_path
    File.join gem_root, 'dynamic-sprites.sass'
  end
end