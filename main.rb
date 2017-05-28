require 'sinatra'
require "sinatra/reloader"
require 'tilt/erubis'

require_relative 'scanner.rb'

def get_haiku
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  scan = Scanner.new(trump_path)

  scan.get_sample_haiku
end

def format_for_twitter(raw_haiku)
  raw_haiku.join("\n").
  gsub(/\n/m, '%0A').
  gsub(/ /, '%20').
  concat('%0A%0Awww%2ETrumpku%2Enet')
end

not_found do
  redirect '/'
end

get '/' do
  @haiku = get_haiku
  @twitter_haiku = format_for_twitter(@haiku)
  erb :home
end

get '/new_haiku' do
  redirect '/'
end
