require_relative 'game'

puts "Welcome to Hangman!\n If you want to load a saved game, type 'load'. If you want to play a new game, type 'new'.\nIf at any point you want to save your game, type 'save' instead of your guess."
inst = gets.chomp
if inst == 'load'
  save = Game.choose_saved
  game = Game.load(save)
else
  game = Game.new  
end
game.play_game