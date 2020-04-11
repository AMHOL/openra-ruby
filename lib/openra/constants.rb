# frozen_string_literal: true

module Openra
  SUPPORT_POWERS = {
    'ra' => {
      'SovietSpyPlane' => :spy_plane,
      'SovietParatroopers' => :paratroopers,
      'UkraineParabombs' => :parabombs,
      'Chronoshift' => :chronoshift,
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
