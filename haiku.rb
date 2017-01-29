require 'pry'

class Word
  attr_reader :raw, :clean, :syllable_count
  attr_accessor :successors

  def initialize(word, successors=[])
    @raw = word
    @clean = gen_clean_word
    @syllable_count = get_syllable_count
    @successors = []
    @end_word = is_end?
  end

  def get_syllable_count
    count = clean.scan(/[aeiou]+/i).length

    if clean =~ /[^aeiou]e\z/ && count > 1
      count -= 1
    elsif clean =~ /[^aeiou]y\z/
      count += 1
    end

    count
  end

  def gen_clean_word
    raw.gsub(/[\W\s]/, '').downcase
  end

  def ==(other_word)
    clean == other_word.clean ? true : false
  end

  def to_s
    clean
  end

  def is_end?
    !!(raw =~ /\.\z/)
  end
end

class Haiku
  attr_reader :text, :words, :all_words

  def initialize(text)
    @text = get_text(text)
    @all_words = []
    @words = generate_words
  end

  def get_text(text)
    if text =~ /\.(md|txt)\z/
      File.open(text, 'r').each.inject('') do |line, string|
        string.concat(line)
      end
    else
      text
    end
  end

  def generate_words
    hash = {}

    text.split.each do |word|
      new_word = Word.new(word)
      all_words << new_word.clean
      hash[new_word.clean] = new_word
    end

    all_words.delete_if { |word| word == '' }

    # populate successors
    hash.each do |clean, word|
      word.successors = get_successors(clean, 6)
    end

    hash
  end

  def get_successors(clean, depth)
    successors = []

    # depth.times do |outer_index|
    #   iteration_successors = []

    #   all_words.each_with_index do |inner_clean, inner_index|
    #     if clean == inner_clean
    #       successor = all_words[inner_index + outer_index + 1]
    #       iteration_successors << successor if successor
    #     end
    #   end
    #   successors << iteration_successors
    # end
    scan_string = clean
    depth.times

    successors
  end

  def get_sum_syllables(arr)
    arr.each.inject(0) do |sum, word|
      sum += word.syllable_count
    end
  end

  def generate_random_line(num_syllables, seed = all_words.sample)
    sum = 0
    line = []

    loop do
      index = 0
      line = [get_successor_word(get_word(seed))]

      while get_sum_syllables(line) < num_syllables
        line << get_successor_word(line.last)
        index += 1
      end

      break if get_sum_syllables(line) == num_syllables ||
               index == 100
    end

    line.join(' ')
  end

  def get_sample_line(len)
    loop_counter = 0

    loop do
      start_index = (0...all_words.length).to_a.sample
      line = []
      sum = 0

      while sum < len do
        line << get_word(all_words[start_index])
        start_index += 1
        sum = get_sum_syllables(line)
      end
  
      loop_counter += 1
      return line.join(' ') if sum == len
      break if loop_counter == 100
    end
  end

  def get_word(str)
    str ? words[str] : words[all_words.sample]
  end

  def get_successor_word(word)
    string = word.successors.empty? ? all_words.sample : word.successors[0].sample
    get_word(string)
  end

  def generate_text(num_words)
    return_arr = []
    return_arr << get_word(all_words.sample)

    num_words.times do |index|
      current = return_arr[index]
      return_arr << get_successor_word(current)
    end

    return_arr.join(' ')
  end

  def print_random_haiku
    first = generate_random_line(5)
    first[0] = first[0].upcase

    middle = generate_random_line(7, first.split.last)
    middle[0] = middle[0].upcase

    last = generate_random_line(5, middle.split.last)
    last[0] = last[0].upcase
    last[-1] == '.' ? last : last.concat('.')

    puts first
    puts middle
    puts last
  end

  def print_sample_haiku
    first = get_sample_line(5)
    first[0] = first[0].upcase
    middle = get_sample_line(7)
    middle[0] = middle[0].upcase
    last = get_sample_line(5)
    last[-1] == '.' ? last : last.concat('.')

    puts first
    puts middle
    puts last
  end

  def to_s
    all_words
  end
end

trump_file_path = "./text_files/trump_address.txt"
moby_file_path = "./text_files/moby-dick.txt"
hemingway_file_path = "./text_files/hemingway.txt"

# haiku = Haiku.new(trump_file_path)
# binding.pry
# haiku.print_random_haiku
# haiku.print_sample_haiku
# p haiku.generate_text(50)
