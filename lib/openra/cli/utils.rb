# frozen_string_literal: true

module Openra
  class CLI
    module Utils
      def utf8(string)
        string.force_encoding('UTF-8')
      end

      def time(msec)
        sec = msec / 1000
        mm, ss = sec.divmod(60)
        hh, mm = mm.divmod(60)

        {
          formatted: '%02d:%02d:%02d' % [hh, mm, ss],
          msec: msec.to_i
        }
      end
    end
  end
end
