require 'pry'
require 'ruby_rhymes'

class Phrases
  attr_accessor :all, :start_phrases, :mid_phrases, :end_phrases, :text

  def initialize(text)
    self.text = get_clean_text(text)
    self.start_phrases = get_start_phrases
    self.mid_phrases = get_mid_phrases
    self.end_phrases = get_end_phrases
  end

  def get_clean_text(text)
    if text =~ /\.(txt|md)\z/
      File.open(text, 'r').each.inject('') do |string, line|
        string.concat(line)
      end
    else
      text
    end.gsub("\n", '')
  end

  def get_start_phrases
    phrases = text.scan(/\.\s+[a-z '-]+/i)
    phrases.map { |phrase| phrase.gsub(/\.\s+/, '').strip }
  end

  def get_mid_phrases
    phrases = text.scan(/[,;]\s[^,.;]+[,;]/i)
    phrases.map { |phrase| phrase.gsub(/[,;]/, '').strip }
  end

  def get_end_phrases
    phrases = text.scan(/[a-z '-]+\.\s/i)
    phrases.map { |phrase| phrase.gsub(/\.\s{0,}/, '').strip }
  end

  def get_syllable_count(word)
    count = 0
    return 0 if word =~ /\A([?!\-—–'";:$%]|--|——)\z/
    # return get_acronym_syllable_count(word) if is_acronym?(word)

    begin
      count = make_english_word(word).to_phrase.syllables
    rescue
      puts "Error thrown with word:"
      p word
    end
      count += 2 if word =~ /[%$]/
      count
  end

  def get_phrase_syllables(string)
    string.split.inject(0) do |sum, word|
      sum += get_syllable_count(word)
    end
  end

  def make_english_word(word)
    return word unless word =~ /\d+/

    word = word.gsub(/,/, '')

    word = word.gsub(/(\d+)/) { decimal_to_word($1) }

    word
  end

  def get_phrase(phase, num_syllables)
    case phase
    when "start"
      loop do
        phrase = start_phrases.sample
        return phrase if get_phrase_syllables(phrase) == num_syllables
      end
    when "mid"
      loop do
        phrase = mid_phrases.sample
        return phrase if get_phrase_syllables(phrase) == num_syllables
      end
    when "end"
      loop do
        phrase = end_phrases.sample
        return phrase if get_phrase_syllables(phrase) == num_syllables
      end
    end
  end

  def decimal_to_word(word)
    # handles decimal numbers 0 to 999999
    word = word.scan(/\d+/)[0]

    decimal = word.to_s.chars.reverse
    word_arr = []

    decimal.each_with_index do |digit, index|
      if index % 3 == 0
        word_arr.push(ONES[digit.to_i])
      elsif index % 3 == 1
        word_arr.push(TENS[digit.to_i])
      elsif index % 3 == 2
        word_arr.push(ONES[digit.to_i] + ' hundred')
      end
    end
    word_arr.reverse!

    if decimal.count > 3
      word_arr[1] == 'ten' ? insert_idx = 3 : insert_idx = 2
      word_arr = word_arr.insert(insert_idx, 'thousand')
    end

    word_arr.delete_if { |word| word =~ /zero/ } unless word_arr.length == 1

    word_str = word_arr.join(' ')

    TEENS.each do |k, v|
      word_str.gsub!(/#{k}/, v)
    end

    word_str
  end
end

trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
p = Phrases.new(trump_path)
binding.pry
