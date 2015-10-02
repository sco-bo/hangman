require_relative 'console'

module HangMan

  class Game
    attr_accessor :chosen_word, :word_reveal, :incorrect_letters_array, :display

    def initialize
      @display = Display.new
      @chosen_word = pick_word
      @turns = 0
      @word_reveal = Array.new
      @incorrect_letters_array = Array.new
      display.gallows
      play_game
    end

    def pick_word
      chosen_word = File.readlines("dictionary.txt").sample.strip.downcase
      while chosen_word.length > 12 || chosen_word.length < 5
        chosen_word = File.readlines("dictionary.txt").sample.strip.downcase
      end
      chosen_word
    end

    def play_game
      puts "The word is:"
      hidden_word
      game_loop
    end

    def hidden_word
      (chosen_word.length).times do 
        word_reveal << "_"
      end
      puts word_reveal.join(" ")
    end

    def user_guess
      puts "Please choose a letter"
      @guess = gets.chomp.downcase
    end

    def game_loop 
      while @turns < 6 && !victory
        evaluate_guess
      end
      game_over
    end

    def evaluate_guess
      puts "#{6 - @turns} guess(es) left"
      if chosen_word.include?(user_guess)
        add_limb(@turns)
        puts "Correct!"
        show_letters(@guess)
        puts word_reveal.join(" ")
        puts "Incorrect letters: #{incorrect_letters_array}"
      else
        @turns += 1
        add_limb(@turns)
        puts word_reveal.join(" ")
        incorrect_guesses(@guess)
        puts "Incorrect letters: #{incorrect_letters_array}"
      end
    end

    def incorrect_guesses(incorrect_guess)
      incorrect_letters_array << incorrect_guess
    end

    def show_letters(guess)
      indices = chosen_word.split("").each_index.select {|i| chosen_word[i] == guess}
      indices.each {|i| word_reveal[i] = guess}
    end

    def game_over
      if @turns == 6
        puts "Game Over!"
        puts "The word was \"#{chosen_word}\""
      end
    end

    def victory
      if word_reveal.join("") == chosen_word
        puts "Victory! You have been spared the gallows."
        display.free
        true
      end
    end

    def add_limb(turns)
      case turns
      when 0 
        display.empty_gallows
      when 1
        display.head
      when 2
        display.right_arm
      when 3
        display.left_arm
      when 4
        display.torso
      when 5
        display.right_leg
      when 6
        display.gallows
      end
    end

  end

  class Display
    attr_reader :delegate

    def initialize(delegate = Console.new)
      puts "Welcome to Hangman!"
      @delegate = delegate
    end

    def gallows
      delegate.gallows
    end

    def empty_gallows
      delegate.empty_gallows
    end

    def head
      delegate.head
    end

    def right_arm
      delegate.right_arm
    end

    def left_arm
      delegate.left_arm
    end

    def torso
      delegate.torso
    end

    def right_leg
      delegate.right_leg
    end

    def free
      delegate.free
    end
  end
end

HangMan::Game.new

