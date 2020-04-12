# frozen_string_literal: true

RSpec.describe 'Openra::CLI::Commands::ReplayData' do
  %w(json pretty-json yaml).each do |format|
    Fixtures.new('replays/input/**/*.orarep').each do |file|
      info = {
        mod: Fixtures.mod_for(file),
        release: Fixtures.release_for(file),
        format: format
      }

      it "does not error for format #{info}" do
        expect {
          capture_output {
            Openra::CLI.new.call(
              arguments: ['replay-data', file, '--format', format]
            )
          }
        }.to_not raise_error
      end

      it "matches expected output for format #{info}" do
        expect(
          capture_output {
            Openra::CLI.new.call(
              arguments: ['replay-data', file, '--format', format]
            )
          }
        ).to match_format(Fixtures.output_for(file, format)).format(format)
      end
    end
  end
end
