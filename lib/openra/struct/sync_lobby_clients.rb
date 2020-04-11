# frozen_string_literal: true

module Openra
  class Struct < Dry::Struct
    class SyncLobbyClients < Openra::Struct
      define do
        attribute :clients, Types::Strict::Array.of(Client).meta(sequence: 'Client')
      end
    end
  end
end
