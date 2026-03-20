require 'json'

class Game
  attr_accessor :board, :guesses_left

  def initialize(word = get_word, board = Array.new(word.length, '_'), correct = Array.new(word.length, false), guesses_left = 8)
    self.word = word
    self.board = board
    self.correct = correct
    self.guesses_left = guesses_left
  end

  def serialize
    JSON.dump({
      word: word,
      board: board,
      correct: correct,
      guesses_left: guesses_left,
    })
  end

  def self.load(save)
    data = JSON.parse(save)
    new(data['word'], data['board'], data['correct'], data['guesses_left'])
  end

  def get_word
    words = File.readlines('google-10000-english-no-swears.txt', chomp: true)
    words_filtered = words.select{|w| w.length >= 5 && w.length <= 12}
    words_filtered[rand(0...words_filtered.length)]
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "saves/#{Time.now}_save.json"
    File.open(filename, 'w') do |file|
      file.puts self.serialize
    end
    puts "Game saved to #{filename}!"
  end

  def self.choose_saved
    if !Dir.exist?('saves') || Dir.empty?('saves')
      puts "Nothing saved!"
      return nil
    end
    filenames = Dir.children('saves')
    filenames.each_with_index do |file, index|
      puts "#{index + 1}: #{file}"
    end
    puts "Choose a file by index"
    selection = gets.chomp.to_i
    if selection <= 0 || selection > filenames.length
      puts "No file at this index"
      return nil
    end
    File.read("./saves/#{filenames[selection - 1]}")
  end

  def check_letter(char)
    letters = word.split('')
    hit = false
    letters.each_with_index do |val, ind|
      if char == val && correct[ind] == false
        self.correct[ind] = true
        self.board[ind] = val
        hit = true
      end
    end
    hit 
  end

  def display_state
    puts board.join(" ")
    if guesses_left == 1
      puts "Last chance!"
    else
      puts "You have #{guesses_left} guesses left!"
    end
  end

  def play_game
    display_state
    while guesses_left > 0
      puts "Your guess: "
      char = gets.chomp.downcase
      if char == 'save'
        save_game
        return nil
      end
      if check_letter(char)
        puts "There you go!"
      else
        puts "Not this time!"
        self.guesses_left -= 1
      end
      display_state
      unless correct.include?(false)
        puts "You got it!"
        return nil
      end
    end
    puts "Game over! The word was #{word}"
  end
  
  private

  attr_accessor :word, :correct
end
