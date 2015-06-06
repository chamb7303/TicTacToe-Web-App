require 'rails_helper'

describe V1::TttGamesController do
  shared_examples_for "not_found response" do
    it "returns 404" do
      subject
      expect(response.status).to eq(404)
    end
  end

  shared_examples_for "unprocessable_entity response" do
    it "returns 422" do
      subject
      expect(response.status).to eq(422)
    end
  end

  describe "#new" do
  end

  describe "#show" do
    subject { get :show, id: id_param }

    context "when record not found" do
      let(:id_param) { 'non-existent-id' }

      it_behaves_like "not_found response"
    end

    context "when record found" do
      let(:ttt_game) { FactoryGirl.build(:ttt_game, players: [primary_player, secondary_player], primary_player_id: primary_player.id) }
      let(:primary_player) { FactoryGirl.build(:user, _id: 'mike') }
      let(:secondary_player) { FactoryGirl.build(:user, _id: 'sara') }
      let(:id_param) { ttt_game.id.to_s }

      before do
        ttt_game.primary_player_id = primary_player.id
        ttt_game.save
      end

      it "returns serialized ttt_game" do
        subject
        expect(JSON.parse(response.body)).to eq({"id"=>"5575273462616e075700004c", "board_state"=>[nil, nil, nil, nil, nil, nil, nil, nil, nil], "primary_player"=>{"name"=>"mike"}, "secondary_player"=>{"name"=>"sara"}})
      end

      it "returns 200" do
        subject
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#create" do
    let(:primary_player_param) { { id: 'mike' } }
    let(:secondary_player_param) { { id: 'sara' } }

    subject { post :create, primary_player: primary_player_param, secondary_player: secondary_player_param }

    context "when invalid params" do
      context "when missing primary_player_param" do
        let(:primary_player_param) { nil }

        it_behaves_like "unprocessable_entity response"
      end

      context "when missing secondary_player_param" do
        let(:primary_player_param) { { id: 'mike' } }
        let(:secondary_player_param) { nil }

        it_behaves_like "unprocessable_entity response"
      end
    end

    context "when valid params" do
      let(:primary_player_param) { { id: 'mike' } }
      let(:secondary_player_param) { { id: 'sara' } }

      context "when save successful" do
        before { expect_any_instance_of(TttGame).to receive(:save).and_return(true) }

        it "returns 200" do
          subject
          expect(response.status).to eq(200)
        end
      end

      context "when save not successful" do
        before { expect_any_instance_of(TttGame).to receive(:save).and_return(false) }

        it_behaves_like "unprocessable_entity response"
      end
    end
  end

  describe "#update" do
    let(:attributes_param) { { board_state: board_state } }
    let(:board_state) { [nil, nil, nil, nil, nil, nil, nil, nil, 'mike'] }

    subject { put :update, id: id_param, attributes: attributes_param }

    context "when record not found" do
      let(:id_param) { 'non-existent-id' }

      it_behaves_like "not_found response"
    end

    context "when record found" do
      let!(:ttt_game) { FactoryGirl.build(:ttt_game) }
      let(:id_param) { ttt_game.id.to_s }

      before do
        ttt_game.primary_player_id = ttt_game.players.first.id
        ttt_game.save
      end

      context "when update successful" do
        before { expect_any_instance_of(TttGame).to receive(:update_attributes).and_return(true) }

        it "returns 201" do
          subject
          expect(response.status).to eq(201)
        end
      end

      context "when update not successful" do
        before { expect_any_instance_of(TttGame).to receive(:update_attributes).and_return(false) }

        it_behaves_like "unprocessable_entity response"
      end
    end
  end
end
