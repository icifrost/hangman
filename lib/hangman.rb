require 'yaml'

class Hangman
  def initialize
    @words = File.readlines('google-10000-english-no-swears.txt', chomp: true)
    @secret_word = @words.sample
    @guessed_letters = []
    @attempts = 6
  end

  def play
    puts "\nWelcome to Hangman!"
    puts "Enter 'new' to start a new game, 'load' to open a saved game, or 'quit' to exit."
    input = gets.chomp.downcase

    case input
    when 'new'
      play_new_game
    when 'load'
      load_game
      continue_game
    when 'quit'
      puts "\nGoodbye!"
    else
      puts "Invalid input. Please try again."
      play
    end
  end

  def play_new_game
    loop do
      puts "\n"
      display_word

      print "\nEnter 'save' to save the game, a letter to guess, or 'quit' to exit: "
      input = gets.chomp.downcase

      case input
      when 'save'
        save_game
        puts "Game saved successfully!"
        next
      when 'quit'
        break
      else
        if input.length != 1 || !input.match?(/[a-z]/)
          puts "Invalid input. Please enter a single letter."
          next
        end

        if @guessed_letters.include?(input)
          puts "You have already guessed that letter."
          next
        end

        @guessed_letters << input

        if @secret_word.include?(input)
          puts "Correct guess!"
        else
          puts "Wrong guess!"
          @attempts -= 1
        end
      end

      break if game_over?

      if word_guessed?
        puts "\nCongratulations! You guessed the word: #{@secret_word}"
        break
      end
    end

    puts "\nThanks for playing Hangman!"
  end

  def display_word
    masked_word = @secret_word.chars.map { |letter| @guessed_letters.include?(letter) ? letter : '_' }
    puts "\nSecret word: #{masked_word.join(' ')}"
    puts "Attempts remaining: #{@attempts}"
  end

  def game_over?
    if @attempts == 0
      puts "\nGame over! You ran out of attempts. The word was #{@secret_word}"
      true
    else
      false
    end
  end

  def word_guessed?
    @secret_word.chars.all? { |letter| @guessed_letters.include?(letter) }
  end

  def save_game
    game_data = {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      attempts: @attempts
    }

    File.open('hangman_save.yml', 'w') do |file|
      file.write(game_data.to_yaml)
    end
  end

  def load_game
    if File.exist?('hangman_save.yml')
      saved_data = YAML.load_file('hangman_save.yml')
      @secret_word = saved_data[:secret_word]
      @guessed_letters = saved_data[:guessed_letters]
      @attempts = saved_data[:attempts]
    else
      puts "\nNo saved game found."
      play_new_game
    end
  end

  def continue_game
    loop do
      puts "\n"
      display_word

      print "\nEnter 'save' to save the game, a letter to guess, or 'quit' to exit: "
      input = gets.chomp.downcase

      case input
      when 'save'
        save_game
        puts "Game saved successfully!"
        next
      when 'quit'
        break
      else
        if input.length != 1 || !input.match?(/[a-z]/)
          puts "Invalid input. Please enter a single letter."
          next
        end

        if @guessed_letters.include?(input)
          puts "You have already guessed that letter."
          next
        end

        @guessed_letters << input

        if @secret_word.include?(input)
          puts "Correct guess!"
        else
          puts "Wrong guess!"
          @attempts -= 1
        end
      end

      break if game_over?

      if word_guessed?
        puts "\nCongratulations! You guessed the word: #{@secret_word}"
        break
      end
    end

    puts "\nThanks for playing Hangman!"
  end
end

hangman = Hangman.new
hangman.play