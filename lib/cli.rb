# frozen_string_literal: true

class CLI
  MIN_CELLS = 2
  MIN_MINES = 1
  MAX_ADJACENT_MINES = 8

  def initialize
    @game = nil
    @rows = 0
    @cols = 0
    @mines = 0
  end

  def start
    loop do
      puts 'Welcome to MineSearcher!'
      puts '1. Start a new game'
      puts '2. Try again' if @game
      puts '3. Exit'
      choice = gets.chomp
      exit if choice.downcase == 'exit'

      choice = choice.to_i

      case choice
      when 1
        start_new_game
        play
      when 2
        repeat_a_game
        play
      when 3
        puts 'Goodbye!'
        break
      else
        puts 'Invalid choice. Please enter 1, 2 or 3.'
      end
    end
  end

  def start_new_game
    @rows = 0
    @cols = 0
    if @rows.zero? || @cols.zero? || @mines.zero?
      @rows, @cols = get_dimensions
      @mines = get_mines(@rows, @cols)
    end
    @game = Game.new(@rows, @cols, @mines)
  end

  def repeat_a_game
    @game = Game.new(@rows, @cols, @mines)
  end

  def get_dimensions
    rows = get_valid_input("Enter the number of rows (minimum #{MIN_CELLS}):", MIN_CELLS)
    cols = get_valid_input("Enter the number of columns (minimum #{MIN_CELLS}):", MIN_CELLS)
    [rows, cols]
  end

  def get_mines(rows, cols)
    min_mines = MIN_MINES
    max_mines = calculate_max_mines(rows, cols)
    get_valid_input("Enter the number of mines (minimum #{min_mines}, maximum #{max_mines}):", min_mines, max_mines)
  end

  def calculate_max_mines(rows, cols)
    if rows <= 2 || cols <= 2
      [[rows * cols - 1, 3].min, MIN_MINES].max
    else
      total_cells = rows * cols
      [total_cells, MAX_ADJACENT_MINES * total_cells / 8].min
    end
  end

  def get_valid_input(prompt, min, max = Float::INFINITY)
    loop do
      puts prompt
      input = gets.chomp
      exit if input.downcase == 'exit'

      input = input.to_i
      return input if input >= min && input <= max

      puts "Invalid input. Please enter a number between #{min} and #{max}."
    end
  end

  def play
    while @game.ongoing?
      display_board
      puts "Enter your move (row, column, and optional 'F' to flag/unflag), 'new' to start a new game, or 'exit' to quit:"
      input = gets.chomp.split
      exit if input[0].downcase == 'exit'

      if input[0].downcase == 'new'
        start_new_game
        next
      end

      row = input[0].to_i - 1
      col = input[1].to_i - 1
      action = input[2] if input.size > 2

      if valid_move?(row, col)
        if action.to_s.downcase == 'f'
          @game.board.grid[row][col].toggle_flag
        else
          @game.reveal(row, col)
        end
      else
        puts 'Invalid move. Try again.'
      end

      @game.status = :won if @game.check_victory
    end

    display_board(true)
    if @game.status == :won
      puts 'Congratulations! You won!'
    else
      puts 'Game Over. You hit a mine!'
    end
  end

  private

  def valid_move?(row, col)
    row.between?(0, @game.rows - 1) && col.between?(0, @game.cols - 1)
  end

  def display_board(reveal_all = false)
    system('clear') || system('cls')

    col_width = 3

    puts 'MineSearcher'
    puts ''
    puts ' ' * (col_width + 1) + (1..@game.cols).map { |num| num.to_s.center(col_width) }.join(' ')
    puts ''

    @game.rows.times do |row|
      print (row + 1).to_s.center(col_width)

      @game.cols.times do |col|
        cell = @game.board.grid[row][col]

        if reveal_all || cell.revealed?
          print " #{cell.to_s.center(col_width)}"
        elsif cell.flagged?
          print " #{cell.to_s.center(col_width)}"
        else
          print " #{'*'.center(col_width)}"
        end
      end
      puts
    end
  end
end
