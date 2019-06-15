$LOAD_PATH.unshift File.dirname(File.expand_path($PROGRAM_NAME))

require 'sinatra'
require 'redcloth' if ENV['REDCLOTH']

require_relative 'wikipage'
require_relative 'simplewiki'

# initialize wiki

before do
  @wiki = SimpleWiki.new
end

post '/save' do
  content = params[:content]
  page_name = params[:page_name]
  #puts "page_name #{page_name}"
  page = WikiPage.new(page_name)
  page.content = content
  page.save

  redirect "/view?page_name=#{page_name}"
end

post '/new' do
  new_page_name = params[:new_page_name]
  new_page_name = new_page_name.underscore_for_space
  redirect "/edit?page_name=#{new_page_name}"
end

post '/search' do
  @search_value = params[:search_value]
  @search_result = @wiki.search_for_text(@search_value)  
  #puts "@search_result: #{@search_result.size}"
  erb :search
end

get '/view' do
  @page_name = params[:page_name]
  #puts "@page_name #{@page_name}"
  page = WikiPage.new(@page_name)
  @page = page
  erb :view
end

get '/printview' do
  @page_name = params[:page_name]
  #puts "@page_name #{@page_name}"
  page = WikiPage.new(@page_name)
  @page = page
  @print_view = true
  erb :view, :layout => :layout_print
end

get '/upload' do
  erb :upload
end

post '/upload' do
  #puts params
  afile = params[:afile]
  #puts "afile: #{afile}"
  filename = afile[:filename]
  #puts "filename: #{filename}"
  tempfile = afile[:tempfile]
  #puts "tempfile: #{tempfile}"
  #puts "tempfile.path: #{tempfile.path}"

  images_path = "public/images/"

  File.open("#{images_path}/#{filename}", 'wb') do |file|
    file.write(File.open(tempfile,'rb').read)
  end
  @notice = "#{filename} was successfully uploaded to: '#{images_path}'"
  erb :upload
end

get '/index' do
  last_page_name = @wiki.last_page_name
  redirect "/view?page_name=#{last_page_name}"
end

get '/edit' do 
  page_name = params[:page_name]
  @page = WikiPage.new(page_name)
  erb :edit
end

get '/' do
  redirect "/index"
end

get '/*' do
  page_name = params[:splat][0]
  #puts "params splat page_name: #{page_name}"
  if page_name =~ /favicon.ico/
    return
  end
  #puts "assume looking for page_name: #{page_name}"
  redirect "/view?page_name=#{page_name}"
end

