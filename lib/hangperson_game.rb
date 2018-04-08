class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError.new('Invalid guess. Guess a letter.') unless letter =~ /[[:alpha:]]/

    letter.downcase!
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter) 
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    return true
  end

  def word_with_guesses
    result = @guesses.empty? ? @word.gsub(/./, '-') : @word.gsub(/[^#{@guesses}]/, '-')
  end

  def check_win_or_lose
    wordStatus = word_with_guesses
    if wordStatus.eql?(@word)
      status = :win
    elsif @wrong_guesses.length > 6 #user gets 7 guesses
      status = :lose
    else
      status = :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
