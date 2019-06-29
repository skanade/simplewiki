require 'yaml'

class LabelIndex
  attr_accessor :labels_hash
  def initialize
    @labels_hash = Hash.new
    @yaml_file = 'label_pages.yml'
  end
  def add_labels(labels_text, page_name)
    puts "labels_hash: #{@labels_hash}"
    labels = labels_text.split(':')[1]
    label_list = labels.split(',')
    label_list.each do |label|
      puts "label: #{label}"
      pages_hash = @labels_hash[label]
      pages_hash = Hash.new unless pages_hash
      pages_hash[page_name] = true
      @labels_hash[label] = pages_hash
    end
  end
  def get_pages(label)
    pages = @labels_hash[label]
    return pages if pages
    return Hash.new
  end
  def save
    File.open(@yaml_file, "w") do |file|
      file.write @labels_hash.to_yaml
    end
  end
  def load
    @labels_hash = YAML.load_file(@yaml_file)
    @labels_hash = Hash.new unless @labels_hash
  end
  def to_s
    "#{@labels_hash}"
  end
end
