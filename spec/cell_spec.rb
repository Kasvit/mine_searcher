# frozen_string_literal: true

require 'rspec'
require_relative '../lib/cell'

RSpec.describe Cell do
  let(:cell) { Cell.new }

  describe '#initialize' do
    it 'is not a mine' do
      expect(cell.mine?).to be false
    end

    it 'is not revealed' do
      expect(cell.revealed?).to be false
    end

    it 'is not flagged' do
      expect(cell.flagged?).to be false
    end

    it 'has zero adjacent mines' do
      expect(cell.adjacent_mines).to eq 0
    end
  end

  describe '#place_mine' do
    it 'sets cell as a mine' do
      cell.place_mine
      expect(cell.mine?).to be true
    end
  end

  describe '#toggle_flag' do
    it 'toggles the flagged state' do
      cell.toggle_flag
      expect(cell.flagged?).to be true
      cell.toggle_flag
      expect(cell.flagged?).to be false
    end
  end

  describe '#reveal' do
    it 'sets cell as revealed' do
      cell.reveal
      expect(cell.revealed?).to be true
    end
  end

  describe '#add_adjacent_mine' do
    it 'increases adjacent mines count' do
      cell.add_adjacent_mine
      expect(cell.adjacent_mines).to eq 1
    end
  end
end
