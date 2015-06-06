require 'rails_helper'

describe V1::TttGameSerializer do
  describe "#to_json" do
    let(:ttt_game) { FactoryGirl.build(:ttt_game, players: [primary_player, secondary_player], primary_player_id: primary_player.id) }
    let(:primary_player) { FactoryGirl.build(:user, _id: 'mike') }
    let(:secondary_player) { FactoryGirl.build(:user, _id: 'sara') }

    subject { V1::TttGameSerializer.new(ttt_game, root: false).to_json }

    before { ttt_game.primary_player_id = primary_player.id }

    it "returns correct serialized object" do
      expected_hash = {
        "id" => ttt_game.id.to_s,
        "board_state" => [nil, nil, nil, nil, nil, nil, nil, nil, nil],
        "primary_player" => {
          "name" => "mike"
        },
        "secondary_player" => {
          "name" => "sara"
        }
      }

      expect(JSON.parse(subject)).to eq(expected_hash)
    end
  end
end
