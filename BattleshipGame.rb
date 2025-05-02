class BattleshipGame
  def initialize(size = 0, language = :en)
    @language = language
    @length = size
    @width = size
    @game_board = create_board
    @hidden_board = create_board

    @board = '=' * ((@length * 2) - 1)
    @play_count = 1
    @score = 0
    @turn_number = 0
    add_ships
  end

  private

  def create_board
    Array.new(@length) { Array.new(@width, '-') }
  end

  def translations
    {
      en: {
        enter_field_size: 'Enter the field size:',
        invalid_size: 'Please enter a number between 5 and 15.',
        choose_row: "Enter the row index to change (0 - #{@length - 1}):",
        choose_column: "Enter the column index to change (0 - #{@width - 1}):",
        wrong_index: 'You entered an incorrect index.',
        miss: 'Miss!',
        hit: 'Hit!',
        your_score: 'Your score:',
        you_won: 'You won!',
        goodbye: 'Goodbye!'
      },
      ja: {
        enter_field_size: 'フィールドサイズを入力してください:',
        invalid_size: '5 ～ 15 の数字を入力してください',
        choose_row: "変更する行インデックスを入力してください (0 - #{@length - 1}):",
        choose_column: "変更したい列のインデックスを入力してください (0 - #{@width - 1}):",
        wrong_index: '間違ったインデックスを入力しました。',
        miss: 'ミス！',
        hit: '命中！',
        your_score: 'あなたのカウント:',
        you_won: 'あなたは勝ちました!',
        goodbye: 'さようなら！'
      }
    }
  end

  def t(key)
    translations[@language][key]
  end

  def add_ships
    ship_data = {
      5..7 => { ships: ['pp', 'ddd', 'aaa'], play_count: 8 },
      8..10 => { ships: ['pp', 'ddd', 'aaa', 'bbbb'], play_count: 12 },
      11..13 => { ships: ['pp', 'ddd', 'aaa', 'bbbb', 'ccccc'], play_count: 17 },
      14..15 => { ships: ['pp', 'pp', 'ddd', 'aaa', 'bbbb', 'bbbb', 'ccccc'], play_count: 23 }
    }

    ships = ship_data.find { |range, _| range.include?(@length) }&.last
    return unless ships

    @play_count = ships[:play_count]

    ships[:ships].each do |ship|
      place_ship(ship)
    end

    print_board
  end

  def place_ship(ship)
    placed = false

    until placed
      direction = rand(2)
      row = direction == 0 ? rand(0..@length - 1) : rand(0..@length - ship.length)
      col = direction == 0 ? rand(0..@width - ship.length) : rand(0..@width - 1)
      intersect = direction == 0 ? @hidden_board[row][col, ship.length].any? { |cell| cell != '-' } :
                                  ship.chars.each_with_index.any? { |_char, i| @hidden_board[row + i][col] != '-' }

      next if intersect

      if direction == 0
        @hidden_board[row][col, ship.length] = ship.chars
      else
        ship.chars.each_with_index { |char, i| @hidden_board[row + i][col] = char }
      end

      placed = true
    end
  end

  def print_board
    puts @board
    puts "Turn #{@turn_number += 1}"
    puts @board
    @game_board.each { |row| puts row.join(' ') }
    puts @board
    game_play
  end

  def game_play
    if @play_count != 0
      row_index = get_input(t(:choose_row), 0, @length - 1)
      col_index = get_input(t(:choose_column), 0, @width - 1)

      point = @hidden_board[row_index][col_index]
      handle_turn(point, row_index, col_index)

      print_board
    elsif @play_count == 0
      puts t(:you_won)
      puts "#{t(:your_score)} #@score"
      puts " "
      puts " "
      puts " "
      puts "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⡋⠁⠀⠀⠀⠀⢀⣀⣀⡀
      ⠀⠀⠀⠀⠀⠠⠒⣶⣶⣿⣿⣷⣾⣿⣿⣿⣿⣛⣋⣉⠀⠀
      ⠀⠀⠀⠀⢀⣤⣞⣫⣿⣿⣿⡻⢿⣿⣿⣿⣿⣿⣦⡀⠀⠀
      ⠀⠀⣶⣾⡿⠿⠿⠿⠿⠋⠈⠀⣸⣿⣿⣿⣿⣷⡈⠙⢆⠀
      ⠀⠀⠉⠁⠀⠤⣤⣤⣤⣤⣶⣾⣿⣿⣿⣿⠿⣿⣷⠀⠀⠀
      ⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⢹⣿⠀⠀⠀
      ⢠⣾⣿⣿⣿⣿⠟⠋⠉⠛⠋⠉⠁⣀⠀⠀⠀⠸⠃⠀⠀⠀
      ⣿⣿⣿⣿⠹⣇⠀⠀⠀⠀⢀⡀⠀⢀⡙⢷⣦⣄⡀⠀⠀⠀
      ⣿⢿⣿⣿⣷⣦⠤⠤⠀⠀⣠⣿⣶⣶⣿⣿⣿⣿⣿⣷⣄⠀
      ⠈⠈⣿⡿⢿⣿⣿⣷⣿⣿⡿⢿⣿⣿⣁⡀⠀⠀⠉⢻⣿⣧
      ⠀⢀⡟⠀⠀⠉⠛⠙⠻⢿⣦⡀⠙⠛⠯⠤⠄⠀⠀⠈⠈⣿
      ⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⡆⠀⠀⠀⠀⠀⠀⠀⢀⠟
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ╦╗════════╔═╗═════╔╦╗══════╗
      ║╩╠═╦═╦═╦╦╗║║╠═╦╦╦╗║║╠═╦═╦╦╗║
      ║╦║╬║╬║╬║║║║║║╩╣║║║╠╗║╩╣╬║╔╝║
      ╚╩╩╩╣╔╣╔╬╗║╚╩╩═╩══╝╚═╩═╩╩╩╝ ║
      ════╚╝╚╝╚═╝═════════════════╝
      "
      puts t(:goodbye)
      exit      
    end
  end

  def get_input(prompt, min, max)
    puts prompt
    input = gets.to_i

    if input < min || input > max
      puts t(:wrong_index)
      get_input(prompt, min, max)
    else
      input
    end
  end

  def handle_turn(point, row_index, col_index)
    puts " "
    puts @board

    case point
    when '-'
      @game_board[row_index][col_index] = 'x'
      @hidden_board[row_index][col_index] = 'x'
      puts t(:miss)
    when 'x', 's'
      puts t(:miss)
    else
      @game_board[row_index][col_index] = 's'
      @hidden_board[row_index][col_index] = 'x'
      @play_count -= 1
      puts t(:hit)
      puts "#{t(:your_score)} #{@score += 10}"
    end

    puts @board
    puts " "
  end
end

# Выбор языка
puts 'Choose language / 言語を選択してください:'
puts '1. English'
puts '2. 日本語'
language_choice = gets.to_i

case language_choice
when 1
  selected_language = :en
when 2
  selected_language = :ja
else
  puts 'Invalid choice. Defaulting to English.'
  selected_language = :en
end

# Запуск игры
loop do
  puts 'Enter the field size (5-15):' if selected_language == :en
  puts 'フィールドサイズを入力してください (5-15):' if selected_language == :ja
  length_in = gets.to_i

  if (5..15).include?(length_in)
    game = BattleshipGame.new(length_in, selected_language)
    break
  else
    puts 'Please enter a number between 5 and 15.' if selected_language == :en
    puts '5 ～ 15 の数字を入力してください' if selected_language == :ja
  end
end