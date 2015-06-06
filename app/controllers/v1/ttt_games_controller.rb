class V1::TttGamesController < ApplicationController
  before_filter :set_players, only: [:create]
  before_filter :set_ttt_game, only: [:update, :show]
  before_filter :normalize_attributes, only: [:update]
  
  def new
  end

  def update
    if @ttt_game.update_attributes(update_params)
      head :created
    else
      head :unprocessable_entity
    end
  end

  def create
    head :unprocessable_entity and return unless (ttt_game = TttGame.new(players: @players, primary_player_id: @primary_player.id)).save

    render json: V1::TttGameSerializer.new(ttt_game, root: false).to_json
  end

  def show
    render json: V1::TttGameSerializer.new(@ttt_game, root: false).to_json
  end

  private
  def set_players
    head :unprocessable_entity and return if (primary_id = params[:primary_player].try(:delete, :id)).blank? || (secondary_id = params[:secondary_player].try(:delete, :id)).blank?

    @primary_player = User.find_or_instantiate(_id: primary_id)
    secondary_player = User.find_or_instantiate(_id: secondary_id)
    @players = [@primary_player, secondary_player]
  end

  def set_ttt_game
    head :not_found and return unless (@ttt_game = TttGame.where(_id: params[:id]).first).present?
  end

  def normalize_attributes
    if (attrs = params[:attributes]).present?
      attrs[:board_state] = attrs[:board_state].split(',').map(&:presence) if attrs[:board_state].present?
    end
  end

  def update_params
    params.require(:attributes).permit(board_state: [])
  end
end
