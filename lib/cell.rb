# frozen_string_literal: true

class Cell
  attr_accessor :has_mine, :revealed, :flagged
  attr_reader :adjacent_mines

  def initialize
    @has_mine = false
    @revealed = false
    @flagged = false
    @adjacent_mines = 0
  end

  def to_s
    return 'X' if revealed && has_mine
    return 'F' if flagged
    return ' ' if revealed && adjacent_mines.zero?

    revealed ? adjacent_mines.to_s : '*'
  end

  def reveal
    @revealed = true
  end

  def toggle_flag
    @flagged = !@flagged
  end

  def empty?
    !has_mine && adjacent_mines.zero?
  end

  def place_mine
    @has_mine = true
  end

  def add_adjacent_mine
    @adjacent_mines += 1
  end

  def mine?
    @has_mine
  end

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end
end