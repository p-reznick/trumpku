require 'sinatra'
require "sinatra/reloader"
require 'tilt/erubis'
require 'sequel'

require_relative 'haiku.rb'

// switch to persistent db
DB = Sequel.sqlite

def setup_db
  puts 'SETTING UP DB!'
  DB.create_table :sentences do
    primary_key :id
    String :text
    Integer :syllables
  end
end

def populate_db
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
end

setup_db()
populate_db()

def get_haiku
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  haiku = Haiku.new(trump_path)

  haiku.get_sample_haiku
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
