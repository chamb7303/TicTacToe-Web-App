require 'rails_helper'

describe TttGame do
  describe "#primary_player" do
    let(:ttt_game) { FactoryGirl.build(:ttt_game) }
    let(:primary_player) { ttt_game.players.first }

    subject { ttt_game.primary_player }

    before { ttt_game.primary_player_id = primary_player_id }

    context "when primary_player_id present" do
      let(:primary_player_id) { primary_player.id }

      it "returns primary_player" do
        expect(subject).to eq(primary_player)
      end
    end

    context "when primary_player_id not present" do
      let(:primary_player_id) { nil }

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end

  describe "#secondary_player" do
    let(:ttt_game) { FactoryGirl.build(:ttt_game) }
    let(:primary_player) { ttt_game.players.first }
    let(:secondary_player) { ttt_game.players.last }

    subject { ttt_game.secondary_player }

    before { ttt_game.primary_player_id = primary_player.id }

    it "returns secondary_player" do
      expect(subject).to eq(secondary_player)
    end
  end
end
