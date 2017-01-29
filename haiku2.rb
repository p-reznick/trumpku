# copyrith
require 'pry'

class Scanner
  attr_accessor :text, :all_words, :sentences

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

  def initialize(text)
    @text = get_text(text)
    @all_words = get_words
    @sentences = get_sentences
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
    # Syllable rules developed in collaboration with Ruta Gajauskaite
    return get_num_syllable_count(word) if word =~ /[0-9]/

    count = word.scan(/[aeiou]+/i).length

    if word =~ /[^aeiou]e\z/ && count > 1
      count -= 1
    elsif word =~ /[^aeiou]y\z/
      count += 1
    elsif word =~ /%/
      count += 2
    end

    count
  end

  def get_num_syllable_count(word)
    word = decimal_to_word(word)
    word.split.each.inject(0) do |sum, w|
      sum += get_syllable_count(w)
    end
  end

  def decimal_to_word(word)
    # handles decimal numbers 0 to 999999
    word = word.scan(/[0-9]+/)[0]

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

scan = Scanner.new('./public/text_files/trump_speeches/trump-speeches-master/speeches.txt')
# p scan.get_sentences
p scan.get_phrase_syllables('Probably 55 years old')
