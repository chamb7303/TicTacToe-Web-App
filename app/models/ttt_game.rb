class TttGame
  include Mongoid::Document

  field :board_state, type: Array
  field :primary_player_id, type: String

  embeds_many :players, class_name: User.to_s

  EMPTY_BOARD_STATE = [nil] * 9

  def primary_player
    players.detect { |p| p.id.to_s == primary_player_id }.presence
  end

  def secondary_player
    players.detect { |p| p.id != primary_player_id }.presence
  end
end
