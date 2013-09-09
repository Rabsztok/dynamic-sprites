Gem::Specification.new do |s|
  s.name        = 'dynamic-sprites'
  s.version     = '0.0.3'
  s.executables << 'dynamic-sprites'
  s.date        = '2013-09-09'
  s.summary     = "Responsive sprites - SASS mixin and sprite generator"
  s.description = "Generates sass mixin and combines directory of images into one sprite"
  s.authors     = ["Maciej Walusiak"]
  s.email       = 'rabsztok@gmail.com'
  s.files       = ["lib/dynamic-sprites.rb", "lib/dynamic-sprites/runner.rb", "lib/dynamic-sprites/generator.rb", "lib/dynamic-sprites/interface.rb", "dynamic-sprites.sass"]
  s.homepage    = 'https://github.com/Rabsztok/dynamic-sprites'
  s.license     = 'GPL'
end