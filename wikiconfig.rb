require 'yaml'

class WikiConfig
  def initialize
    @config = YAML::load(File.open('simplewiki.yaml'))
  end
  def last_num_pages
    @config[:last_num_pages]
  end
  def favorites
    @config[:favorites]
  end
end
