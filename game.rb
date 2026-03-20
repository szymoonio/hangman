class Game
  @@game_count = 0

  attr_accessor :id, :board, :guesses_left, :letters_left, :letters_guessed

  def initialize
    @@game_count += 1
    self.id = @@game_count
    self.word = get_word
    self.board = '_ ' * word.length
    self.correct = Array.new(word.length, false)
    self.guesses_left = 8
  end

  def get_word
    words = File.readlines('google-10000-english-no-swears.txt', chomp: true)
    words_filtered = words.select{|w| w.length >= 5 && w.length <= 12}
    words_filtered[rand(0...words_filtered.length)]
  end

  def check_letter(char)
    letters = word.to_a
    correct = false
    letters.each_with_index do |val, ind|
      if char == val && correct[ind] == false
        self.correct[ind] = true
        self.board[ind] = val
        correct = true
      end
    end
    self.guesses_left -= 1
    correct  
  end

  def display_state
    puts board
    if guesses_left == 1
      puts "Last chance!"
    else
      puts "You have #{guesses_left} left!"
    end
  end

  def play_game
    while guesses_left > 0
      display_state
      puts "Your guess: "
      char = gets.chomp
      if check_letter(char)
        puts "There you go!"
      else
        "Not this time!"
      end
      unless correct.includes(false)
        puts "You got it!"
        return
      end
    end
    puts "Game over!"
  end
  
  private

  attr_accessor :word, :correct
end
g = Game.new
p g