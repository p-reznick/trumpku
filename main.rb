require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require_relative 'haiku.rb'

MONTHS = %w(Jan Feb Mar Apr May June July Aug Sep Oct Nov Dec)

configure do
  set :haiku_count, 0
  t = Time.now
  # set :startup_date, "#{t.day} #{MONTHS[t.month - 1]}"
  set :startup_date, t.to_s
end

def get_haiku
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  scan = Scanner.new(trump_path)

  settings.haiku_count += 1

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
  @haiku_count = settings.haiku_count
  @startup_date = settings.startup_date
  @haiku = get_haiku
  @twitter_haiku = format_for_twitter(@haiku)
  erb :home
end

get '/new_haiku' do
  redirect '/'
end
