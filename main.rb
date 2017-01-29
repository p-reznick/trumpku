require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require_relative 'haiku2.rb'

not_found do
  redirect '/'
end

get '/' do
  scan = Scanner.new('./public/text_files/trump.txt')
  @haiku = scan.get_sample_haiku
  erb :home
end
