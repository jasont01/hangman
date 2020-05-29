require 'json'

def get_secret
  secret = ""

  while secret.length < 5 || secret.length > 12 do
    secret = File.readlines("dictionary.dat").sample
  end

  secret.downcase.chomp.split("")
end

def display_game(game)
  puts "========HANGMAN========="
  puts
  puts "Guesses Remaining: #{game['guesses']}"
  puts
  puts game['word'].join(' ')
  puts
  puts game['letters'].join(' ')
end

def get_guess
  puts "Enter 'menu' to return to menu"
  puts "Enter 'save' to save game"
  puts "Pick Letter: "
  guess = gets.chomp.downcase
  guess
end

def check_guess(game, guess)
  menu if guess == "menu"
  save_game(game) if guess == "save"

  correct_guess = false
  game['letters'].map! {|i| i == guess ? ' ' : i}

  game['secret'].each_index do |i| 
    if game['secret'][i] == guess
      game['word'][i] = guess
      correct_guess = true
    end
  end
  game['guesses'] -= 1 if !correct_guess
end

def missing_letters(word)
  num_missing = 0
  word.map {|i| num_missing += 1 if i == '_'}
  num_missing
end

def save_game(game)
  save_file = File.open($file_name, "w")
  save_file.write(game.to_json)
  save_file.close
  menu
end

def load_game
  save_file = File.open($file_name, "r")
  game = JSON.load save_file.read
  save_file.close
  play_game(game)
end

def menu
  choice = 0
  puts "===Main Menu==="
  puts ""
  puts "[1] New Game"
  puts "[2] Load Game"
  puts "[3] Quit"
  puts ""
  puts "Enter Choice: "
  choice = gets.chomp
  new_game if choice == "1"
  load_game if choice == "2"
  exit if choice == "3"
end

def new_game
  secret = get_secret
  game = { "secret" => secret, "guesses" => 6, "letters" => ('a'..'z').to_a, "word" => Array.new(secret.length, "_") }
  p game
  play_game(game)
end

def play_game(game)
  p game['secret'] ##testing

  while game['guesses'] > 0 && missing_letters(game['word']) > 0
    display_game(game)
    check_guess(game, get_guess)
  end

  game_end(game)
end

def game_end(game)
  if game['guesses'] == 0
    puts "You Lose!"
    puts "The word was:"
    puts game['secret'].join("")
  else
    puts game['word'].join(' ')
    puts "You Win!"
  end
end

$file_name = "hangman.sav"
menu
