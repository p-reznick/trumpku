# require_relative "./haiku.rb"
require 'pry'

class Scanner
  attr_accessor :text, :all_words, :sentences

  def initialize(text)
    @text = get_text(text)
    @all_words = get_words
    @sentences = get_sentences
  end

  def get_text(text)
    if text =~ /\.(txt|md)\z/
      return_string = ''
      File.open(text, 'r').each.inject('') do |string, line|
        string.concat(line)
      end
    else
      text
    end
  end

  def get_word_syllables(word)
    count = word.scan(/[aeiou]+/i).length

    if word =~ /[^aeiou]e\z/ && count > 1
      count -= 1
    elsif word =~ /[^aeiou]y\z/
      count += 1
    end

    count
  end

  def get_phrase_syllables(string)
    string.split.inject(0) do |sum, word|
      sum += get_word_syllables(word)
    end
  end

  def get_sentences
    text.split(/[(\.)(\,)]/).map do |s|
      s.gsub(/\n/, '').strip
    end
  end

  def get_words
    processed_words = []
    text.split.each do |word|
      processed_words << word
    end
    processed_words
  end

  def get_syll_sentences(num_syls)
    matches = sentences.select do |s|
      get_phrase_syllables(s) == num_syls
    end
    matches.empty? ? ['no dice'] : matches
  end

  def print_sample_haiku
    first = get_syll_sentences(5).sample
    second = get_syll_sentences(7).sample
    third = get_syll_sentences(5).sample

    # puts get_syll_sentences(10).sample + ' ' + get_syll_sentences(7).sample
    puts format_haiku(first, second, third)
  end

  def get_sample_haiku
    first = get_syll_sentences(5).sample
    second = get_syll_sentences(7).sample
    third = get_syll_sentences(5).sample

    [first, second, third].map do |l|
      l[0] = l[0].upcase
      l
    end

    [first, second, third + '.']
  end

  def format_haiku(line_1, line_2, line_3)
    [line_1, line_2, line_3].map do |l|
      l[0] = l[0].upcase
      l
    end.join("\n") + '.'
  end
end

trump_file_path = "./public/text_files/trump.txt"
moby_file_path = "/text_files/moby-dick.txt"
hemingway_file_path = "/text_files/hemingway.txt"
