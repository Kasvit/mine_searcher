# frozen_string_literal: true

class Game
  attr_accessor :status
  attr_reader :rows, :cols, :board

  def initialize(rows, cols, mines)
    @rows = rows
    @cols = cols
    @mines = mines
    @status = :ongoing
    @board = Board.new(rows, cols, mines)
  end

  def reveal(row, col)
    cell = @board.grid[row][col]
    if cell.has_mine
      cell.flagged = false
      @status = :lost
      reveal_all_mines
    else
      @board.reveal(row, col)
    end
  end

  def ongoing?
    @status == :ongoing
  end

  def check_victory
    @board.grid.flatten.none? { |cell| !cell.revealed? && !cell.has_mine }
  end

  def reveal_all_mines
    @board.grid.each do |row|
      row.each(&:reveal)
    end
  end
end
