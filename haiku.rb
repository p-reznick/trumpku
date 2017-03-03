require 'pry'

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
  MULTISYLLABLES = %w(ia io ua oi nuclear eo ple\z)

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

    word = make_english_word(word)

    if is_acronym?(word)
      count = get_acronym_syllable_count(word)
    else
      count += word.scan(/[aeiou]+/i).length

      count -= 1 if word =~ /[^aeiouy]e\z/ && count > 1
      count -= 1 if word =~ /[aeiou][^aeiou]e[^oy]/ # internal silent e
      count += MULTISYLLABLES.select { |cluster| word =~ /#{cluster}/ }.count
      count += 1 if word =~ /[^aeiou]y\z/
      count += 2 if word =~ /[%$]/
      count += 1 if word =~ /[&\+@]/
    end

    count
  end

  def get_acronym_syllable_count(word)
    count = 0
    count += word =~ /\./ ? word.length / 2 : word.length
    return word =~ /w/i ? count + 1 : count
  end

  def make_english_word(word)
    return word unless word =~ /\d+/

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
    # words = string.split.inject([]) do |word, all|
    #   result = make_english_word(word)
    #   p result
    #   result =~ /\s/ ? all.concat(result.split) : all << result
    # end

    string.split.inject(0) do |sum, word|
      sum += get_syllable_count(word)
    end
  end

  def get_phrases
    split_pattern = /([;:!?]|,\D|\.\s)/
    phrases = text.split(split_pattern).map do |phrase|
      phrase.gsub(/\n/, '').strip
    end.delete_if { |phrase| phrase =~ /barron/i ||
                             phrase =~ /Mr\./i }
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

# SYLLABLE TEST SUITE
# trump_path = './public/text_files/trump_speeches/trump-speeches-master/speeches.txt'
# test = Scanner.new(trump_path)
# p test.get_syllable_count('') == 0
# p test.get_syllable_count('hey') == 1
# p test.get_syllable_count('bee') == 1
# p test.get_syllable_count('sea') == 1
# p test.get_syllable_count('jeep') == 1
# p test.get_syllable_count('rolled') == 1
# p test.get_syllable_count('peon') == 2
# p test.get_syllable_count('forty') == 2
# p test.get_syllable_count('briar') == 2
# p test.get_syllable_count('prior') == 2
# p test.get_syllable_count('boing') == 2
# p test.get_syllable_count('people') == 2
# p test.get_syllable_count('apple') == 2
# p test.get_syllable_count('controlled') == 2
# p test.get_syllable_count('problems') == 2
# p test.get_syllable_count('homestead') == 2
# p test.get_syllable_count('money') == 2
# p test.get_syllable_count('rodeo') == 3
# p test.get_syllable_count('odeon') == 3
# p test.get_syllable_count('oreo') == 3
# p test.get_phrase_syllables('Within 24 hours')
# p test.make_english_word('24')
# p test.get_syllable_count('nuclear') == 3
# p test.get_syllable_count('adrianople') == 5
# p test.get_phrase_syllables('24 years') == 4
