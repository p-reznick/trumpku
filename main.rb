require 'sinatra'
require "sinatra/reloader"
require 'tilt/erubis'
require 'sequel'

require_relative 'haiku'
require_relative 'parser_helpers'

# switch to persistent db
DB = Sequel.sqlite

def setup_db
  puts 'SETTING UP DB!'
  DB.create_table :sentences do
    primary_key :id
    String :text
    Integer :syllable_count
  end
end

def populate_db
  # read text from path and clean up
  trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
  text = if trump_path =~ /\.(txt|md)\z/
    File.open(trump_path, 'r').each.inject('') do |string, line|
      string.concat(line)
    end
  else
    text
  end.gsub(/(\n|["])/, '')

  # get all sentences
  sentences = text.scan(/[\A\.]\s+[^\.]+\./)

  # write sentences into db
  db_sentences = DB[:sentences]

  sentences.each do |sentence|
    syllable_count = get_phrase_syllables(sentence)
    db_sentences.insert(:text => sentence, :syllable_count => syllable_count)
  end

  puts db_sentences.where(:syllable_count => 5).count
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
