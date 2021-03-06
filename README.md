simplewiki
==========

A simple wiki - use it as a personal wiki notebook

https://github.com/skanade/simplewiki/wiki (see screenshot)

Here are steps to get this running on your machine:

1. First, download & install Ruby 2.x (developed with Ruby 1.9.3 originally and runs successfully with Ruby 2.3.3, 2.6.5)

2. Then install the bundler gem
  * gem install bundler

3. Run bundle install to install gems in Gemfile
  * bundle install

3. Install RedCloth gem (optional)
  * gem install RedCloth (optional - you can also run without RedCloth, with a limited subset of markdown)

4. Startup the sinatra instance with:

<pre>
  ruby main.rb
</pre>
   OR if you want to run with RedCloth:
<pre>
  REDCLOTH=true ruby main.rb
</pre>

5. Open a browser to: 

  http://localhost:4567

You should see the last page that was modified, which probably is the 'ruby_index' page.

*Note:* this currently only works on firefox and chrome and safari. It doesn't look quite right on internet explorer.

Enjoy!

#### RedCloth
By default, this simplewiki will run without RedCloth and instead use a limited subset of Markdown which is implemented internally.

If you want to use RedCloth instead, you still can by running with the `REDCLOTH=true` environment variable.  

If you want to use RedCloth on Windows though, you will have to first do the following:
  * install DevKit from: http://rubyinstaller.org/downloads/.  
  * Follow the instructions here first: http://stackoverflow.com/questions/7290868/how-to-install-redcloth-on-windows/7309894#7309894
  * gem install RedCloth

#### Behind a Firewall
If you're behind a firewall and you can't install remote gems, you'll have to download sinatra and its dependencies such as: rack, rack-protection, tilt, and RedCloth as .gem files to your PC.
Then make sure you have LOAD_PATH=. and install each gem:
  * gem install *Gemname* (ex: gem install tilt)

