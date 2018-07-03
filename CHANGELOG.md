## Unreleased

[Compare v1.0.0...HEAD](https://github.com/AMHOL/openra-ruby/compare/v1.0.0...HEAD)

## v1.0.0

## Added

* [core] Clean up internals with structs and better abstractions ([AMHOL](https://github.com/AMHOL))
* [replay-data] Added duration struct to game output (formatted/msec) ([AMHOL](https://github.com/AMHOL))
* [replay-data] Added support for YAML output format ([AMHOL](https://github.com/AMHOL))

## Removed

* [replay-data] Removed duration (seconds) field from game output ([AMHOL](https://github.com/AMHOL))

[Compare v0.3.0...v1.0.0](https://github.com/AMHOL/openra-ruby/compare/v0.3.0...v1.0.0)

## v0.3.0

## Fixed

* [replay-data] Fix "type" output when no teams set ([AMHOL](https://github.com/AMHOL))
* [replay-data] Fix error uninitialized constant Openra::CLI::Commands::ReplayData::SecureRandom ([AMHOL](https://github.com/AMHOL))

[Compare v0.2.0...v0.3.0](https://github.com/AMHOL/openra-ruby/compare/v0.2.0...v0.3.0)

## v0.2.0

## Added

* [replay-data] Show chosen and actual faction ([AMHOL](https://github.com/AMHOL))
* [replay-data] Add spawn point info

## Fixed

* [replay-data] Fetch team from replay metadata players hash ([AMHOL](https://github.com/AMHOL))

[Compare v0.1.0...v0.2.0](https://github.com/AMHOL/openra-ruby/compare/v0.1.0...v0.2.0)

## v0.1.0

## Added

* Include server and team chat messages in replay data ([AMHOL](https://github.com/AMHOL))
* Include is_winner replay data client output ([AMHOL](https://github.com/AMHOL))

## Fixed

* Return `null` for client team in replay data when team is not set ([AMHOL](https://github.com/AMHOL))

[Compare v0.0.5...v0.1.0](https://github.com/AMHOL/openra-ruby/compare/v0.0.5...v0.1.0)
