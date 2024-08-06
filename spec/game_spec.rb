# frozen_string_literal: true

require 'rspec'
require_relative '../lib/game'
require_relative '../lib/board'

RSpec.describe Game do
  let(:game) { Game.new(5, 5, 5) }

  describe '#initialize' do
    it 'sets the initial status to ongoing' do
      expect(game.status).to eq :ongoing
    end
  end

  describe '#reveal' do
    it 'ends the game if a mine is revealed' do
      cell = game.board.grid[0][0]
      cell.place_mine
      game.reveal(0, 0)
      expect(game.status).to eq :lost
    end
  end

  describe '#check_victory' do
    it 'returns true if all non-mine cells are revealed' do
      game.board.grid.flatten.each do |cell|
        cell.reveal unless cell.mine?
      end
      expect(game.check_victory).to be true
    end
  end

  describe '#reveal_all_mines' do
    it 'reveals all mines on the board' do
      cell = game.board.grid[0][0]
      cell.place_mine
      game.reveal_all_mines
      expect(game.board.grid.flatten.count { |cell| cell.revealed? && cell.mine? }).to be > 0
    end
  end
end
