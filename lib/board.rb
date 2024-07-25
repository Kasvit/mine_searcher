# frozen_string_literal: true

class Board
  attr_reader :rows, :cols, :grid

  def initialize(rows, cols, mines)
    @rows = rows
    @cols = cols
    @mines = mines
    @grid = Array.new(rows) { Array.new(cols) { Cell.new } }
    place_mines
    calculate_adjacent_mines
  end

  def place_mines
    placed_mines = 0
    while placed_mines < @mines
      row = rand(@rows)
      col = rand(@cols)
      next if @grid[row][col].mine?

      @grid[row][col].place_mine
      placed_mines += 1
    end
  end

  def calculate_adjacent_mines
    @rows.times do |row|
      @cols.times do |col|
        next if @grid[row][col].mine?

        adjacent_cells(row, col).each do |adj_row, adj_col|
          @grid[row][col].add_adjacent_mine if @grid[adj_row][adj_col].mine?
        end
      end
    end
  end

  def adjacent_cells(row, col)
    adjacent_coords = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]
    adjacent_coords.map { |r, c| [row + r, col + c] }
                   .select { |r, c| r.between?(0, @rows - 1) && c.between?(0, @cols - 1) }
  end

  def reveal(row, col)
    cell = @grid[row][col]
    return if cell.revealed?

    cell.reveal
    return unless cell.empty?

    adjacent_cells(row, col).each { |adj_row, adj_col| reveal(adj_row, adj_col) }
  end
end
