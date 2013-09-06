dynamic-sprites [![Code Climate](https://codeclimate.com/github/Rabsztok/dynamic-sprites.png)](https://codeclimate.com/github/Rabsztok/dynamic-sprites) [![Dependency Status](https://gemnasium.com/Rabsztok/dynamic-sprites.png)](https://gemnasium.com/Rabsztok/dynamic-sprites)
===============

Dynamic Sprites is a ruby gem which helps managing your [responsive sprites](http://blog.growthrepublic.com/2013/08/30/responsive-sprites-using-sass/).
On initialization, it creates sass mixin, which will generate for you all of the necessary styles needed for handling your sprite image.
It has also a generator for your own sprite images. Its functionality is explained below.

Installation
============

    $ gem install dynamic-sprites

When gem is installed, you have to run 'init' command which will generate sass mixin (optionally, you could append path to where it should be placed as a second argument):

    $ dynamic-sprites init

An image library is also required. DynamicSprites comes with built in support for
[RMagick](http://rmagick.rubyforge.org/).

RMagick is the most common image libary to use, installation instructions for ubuntu:

    $ sudo aptitude install imageMagick libMagickWand-dev
    $ sudo gem install rmagick

Usage
=====

Use the `dynamic-sprites generate` command line script specifying the location of your images.

    $ dynamic-sprites generate images/icons

This will combine the individual image files within that directory and generate sprite containing all of images placed in that directory

You can also use the DynamicSprites directly from your own code:

    require 'dynamic-sprites'

    DynamicSprites.run!('generate', 'images/icons')

Customization
=============

You can provide these options to customize generation process:

 - `:layout`       - specify layout algorithm - how images should be combined (horizontal or vertical)
 - `:output`       - specify output location for generated image (default: <input folder>.png)
 - `:selector`     - specify selector for created sprite (default: img.sprite)

Options can be passed as command line arguments to the `dynamic-sprites` script:

    $ dynamic-sprites images/icons --output sass/dynamic-sprites.sass --layout horizontal

Options can also be passed as the 2nd argument to the `#run!` method:

    DynamicSprites.run!('generate', 'images/icons', output: 'sass/dynamic-sprites.png', layout: 'horizontal')

ToDo
====

There is plenty of work to do here, share with me your feedback or make some pull requests if you like it.

    * Create solid validation for input options, currently when you pass an invalid option you will get normal ruby error instead of nice looking message.
    * Create good Unit Tests to cover all of provided functionality. Currently there are only integration tests for core functions.

License
=======

See [LICENSE](https://github.com/Rabsztok/dynamic-sprites/blob/master/LICENSE) file.

Credits
=======

Thanks to [jakesgordon](https://github.com/jakesgordon) who created awesome gem [sprite-factory](https://github.com/jakesgordon/sprite-factory) which inspired me and provided tons of great ideas during development.
Also big thanks to my employer, [GrowthRepublic](http://growthrepublic.com) for encouraging me to release this library as open source.

Contact
=======

If you have any ideas, feedback, requests or bug reports, you can reach me at
[rabsztok@gmail.com](mailto:rabsztok@gmail.com).