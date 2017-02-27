require 'dalli'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require_relative 'haiku.rb'
require_relative 'memcachier_setup.rb'

MONTHS = %w(Jan Feb Mar Apr May June July Aug Sep Oct Nov Dec)

configure do
  startup_date = CACHE.get('start_date') || Time.now
  set :startup_date, startup_date
end

def increment_count
  CACHE.set('haiku_count', get_count + 1)
end

def get_count
  CACHE.get('haiku_count') || 0
end

def get_haiku
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  scan = Scanner.new(trump_path)

  increment_count

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
  @haiku_count = get_count
  @startup_date = settings.startup_date
  @haiku = get_haiku
  @twitter_haiku = format_for_twitter(@haiku)
  erb :home
end

get '/new_haiku' do
  redirect '/'
end
