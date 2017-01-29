require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require_relative 'haiku2.rb'

not_found do
  redirect '/'
end

get '/' do
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  scan = Scanner.new(trump_path)
  @haiku = scan.get_sample_haiku
  erb :home
end
