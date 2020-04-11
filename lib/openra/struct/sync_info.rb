# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class SyncInfo < Openra::Struct
      define do
        attribute :clients, Types::Strict::Array.of(Client).meta(sequence: 'Client')
        attribute :global_settings, GlobalSettings.meta(
          from: 'GlobalSettings'
        )
      end
    end
  end
end
