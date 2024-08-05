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
    @flags = 0
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
    @flags = 0
  end

  def repeat_a_game
    @flags = 0
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
    total_cells = rows * cols
    min_cells_without_mines = (rows - 1) * (cols - 1)
    max_mines = [total_cells - min_cells_without_mines, total_cells - 1].min
    max_mines = [max_mines, MAX_ADJACENT_MINES].min if rows == 3 && cols == 3
    max_mines
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
        cell = @game.board.grid[row][col]
        if action.to_s.downcase == 'f'
          next if cell.revealed || (!cell.flagged? && @flags >= @mines)

          action = nil
          cell.toggle_flag
          cell.flagged? ? @flags += 1 : @flags -= 1
        else
          @game.reveal(row, col)
        end
        break if @game.status == :lost

        @game.status = :won if @game.check_victory
      else
        puts 'Invalid move. Please enter a valid row and column within the board boundaries.'
      end
    end

    display_board(true)
    puts @game.status == :won ? colorize('Congratulations, you won!', :green) : colorize('Game over, you lost.', :red)
  end

  def valid_move?(row, col)
    row.between?(0, @game.rows - 1) && col.between?(0, @game.cols - 1)
  end

  def display_board(reveal_all = false)
    system('clear') || system('cls')

    col_width = 3

    puts "MineSearcher - Mines: #{@mines}, Flags: #{@flags}"
    puts ''
    puts ' ' * (col_width + 1) + (1..@game.cols).map { |num| num.to_s.center(col_width) }.join(' ')
    puts ''

    @game.rows.times do |row|
      print (row + 1).to_s.center(col_width)

      @game.cols.times do |col|
        cell = @game.board.grid[row][col]

        if reveal_all || cell.revealed?
          cell_display = colorize(cell.to_s.center(col_width), cell_color(cell))
        elsif cell.flagged?
          cell_display = colorize('F'.center(col_width), :cyan)
        else
          cell_display = "*".center(col_width)
        end

        print " #{cell_display}"
      end
      puts
    end
  end

  def cell_color(cell)
    return :red if cell.mine?

    case cell.adjacent_mines
    when 1..3 then :yellow
    when 4..5 then :blue
    else :magenta
    end
  end

  def colorize(text, color)
    colors = {
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      white: 37
    }
    "\e[#{colors[color]}m#{text}\e[0m"
  end
end
