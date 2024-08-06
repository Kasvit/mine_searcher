# frozen_string_literal: true

require 'rspec'
require_relative '../lib/board'
require_relative '../lib/cell'

RSpec.describe Board do
  let(:board) { Board.new(5, 5, 5) }

  describe '#initialize' do
    it 'creates a grid with the correct number of rows and columns' do
      expect(board.rows).to eq 5
      expect(board.cols).to eq 5
    end
  end

  describe '#reveal' do
    it 'reveals the specified cell' do
      board.reveal(1, 1)
      cell = board.grid[1][1]
      expect(cell.revealed?).to be true
    end
  end

  describe '#place_mines' do
    it 'places the correct number of mines' do
      mines = board.instance_variable_get(:@mines)
      expect(board.grid.flatten.count(&:mine?)).to eq mines
    end
  end
end
