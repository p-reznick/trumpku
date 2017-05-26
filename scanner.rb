require 'pry'
require 'ruby_rhymes'

class Scanner
  attr_accessor :text, :all_words, :phrases

  ONES = %w(zero one two three four five six seven eight nine)
  TENS = %w(zero ten twenty thirty forty fifty sixty seventy eighty ninety)
  TEENS = {'ten one' => 'eleven',
           'ten two' => 'twelve',
           'ten three' => 'thirteen',
           'ten four' => 'fourteen',
           'ten five' => 'fifteen',
           'ten six' => 'sixteen',
           'ten seven' => 'seventeen',
           'ten eight' => 'eighteen',
           'ten nine' => 'nineteen'}
  MULTISYLLABLES = %w(ia io[^n] ua oi ed\z nuclear eo [^aeiou]le\z)

  def initialize(text)
    @text = get_text(text)
    @all_words = get_words
    @phrases = get_phrases
  end

  def get_text(text)
    if text =~ /\.(txt|md)\z/
      File.open(text, 'r').each.inject('') do |string, line|
        string.concat(line)
      end
    else
      text
    end
  end

  def get_syllable_count(word)
    count = 0
    return 0 if word =~ /\A([?!\-—–'";:$%]|--|——)\z/
    return get_acronym_syllable_count(word) if is_acronym?(word)

    begin
      count = make_english_word(word).to_phrase.syllables
    rescue
      puts "Error thrown with word:"
      p word
    end
      count += 2 if word =~ /[%$]/
      count
  end

  def get_acronym_syllable_count(word)
    count = 0
    count += word =~ /\./ ? word.length / 2 : word.length
    return word =~ /w/i ? count + 1 : count
  end

  def make_english_word(word)
    return word unless word =~ /\d+/

    word = word.gsub(/,/, '')

    word = word.gsub(/(\d+)/) { decimal_to_word($1) }

    word
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

  def get_phrase_syllables(string)
    string.split.inject(0) do |sum, word|
      sum += get_syllable_count(word)
    end
  end

  def get_phrases
    split_pattern = /([;:!?]|,\D|\.)/
    all = text.split(split_pattern).map do |phrase|
      phrase.gsub(/\n/, '').strip
    end

    all.delete_if { |phrase| phrase =~ /barron/i ||
                             phrase =~ /\A[.?,]\z/ }
  end

  def get_words
    processed_words = []
    text.split.each do |word|
      processed_words << word
    end
    processed_words
  end

  def get_syll_phrase(num_sylls)
    counter = 0

    while counter < 1000 do
      phrase = phrases.sample
      return phrase if get_phrase_syllables(phrase) == num_sylls
      counter += 1
    end
  end

  def get_splittable_syll_phrase(total_sylls, sub_sylls)
    counter = 0
    loop do
      phrase = get_syll_phrase(total_sylls)
      return phrase if is_splittable?(phrase, sub_sylls)
      break if counter > 1000
    end

    return 'no dice'
  end

  def is_splittable?(phrase, num_sylls)
    sum = 0

    phrase.split.each do |word|
      sum += get_syllable_count(word)
      return true if sum == num_sylls
      return false if sum > num_sylls
    end

    false
  end

  def get_sample_haiku
    opt = [1, 2, 3].sample
    raw_haiku = ''

    case opt
    when 1
      raw_haiku = get_syll_phrase(5) + ' ' +
                  get_splittable_syll_phrase(12, 7)
    when 2
      raw_haiku = get_splittable_syll_phrase(12, 5) + ' ' +
                  get_syll_phrase(5)
    when 3
      raw_haiku = get_syll_phrase(5) + ' ' +
                  get_syll_phrase(7) + ' ' +
                  get_syll_phrase(5)
    end

    format_haiku(raw_haiku)
  end

  def format_haiku(text)
    haiku = ''
    words = text.gsub(/"/, '').split

    words.each do |word|
      next if word =~ /[\-—–]/
      haiku.concat(word + ' ')
      haiku.concat("\n") if get_phrase_syllables(haiku) == 5 ||
                            get_phrase_syllables(haiku) == 12
    end

    haiku.rstrip!.concat('.')

    haiku.split("\n").map do |line|
      line[0] = line[0].upcase
      line
    end
  end

  def is_acronym?(word)
    (word =~ /(\A([A-Z]\.){2,}+\z|\A([A-Z]){2,}+\z)/) ? true : false
  end

  def to_s
    puts "total words: #{all_words.count}"
    puts "total phrases: #{phrases.count}"
  end
end
