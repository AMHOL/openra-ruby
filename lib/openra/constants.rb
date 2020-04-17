# frozen_string_literal: true

module Openra
  # # https://github.com/OpenRA/OpenRA/blob/23b3c237b7071fd308c4664b0b6c5d719c0f3c74/OpenRA.Game/Map/MapPlayers.cs
  # The player index is stored in the subject_id on orders to indicate which
  # player issued the order, this is used because bot orders are issued by the
  # host client
  # I think the indices are as follows, but may differ for scripted maps:
  # 0 => World
  # 1 => Neutral
  # 2 => Creeps
  # 3 => Players@{0}
  # 4 => Players@{1}
  # 5 => ...
  FIRST_PLAYER_INDEX = 3

  SUPPORT_POWERS = {
    'ra' => {
      'SovietSpyPlane' => :spy_plane,
      'SovietParatroopers' => :paratroopers,
      'UkraineParabombs' => :parabombs,
      'Chronoshift' => :chronoshift,
      'AdvancedChronoshift' => :chronoshift,
      'NukePowerInfoOrder' => :nuke,
      'GrantExternalConditionPowerInfoOrder' => :iron_curtain
    },
    'cnc' => {
      'AirstrikePowerInfoOrder' => :airstrike,
      'IonCannonPowerInfoOrder' => :ion_cannon,
      'NukePowerInfoOrder' => :nuke
    }
  }.freeze
end
