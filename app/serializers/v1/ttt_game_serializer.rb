class V1::TttGameSerializer < ActiveModel::Serializer
  attributes :id, :board_state, :primary_player, :secondary_player

  def id
    object.id.to_s
  end

  def board_state
    object.board_state || TttGame::EMPTY_BOARD_STATE
  end

  def primary_player
    { name: object.primary_player.id }
  end

  def secondary_player
    { name: object.secondary_player.id }
  end
end
