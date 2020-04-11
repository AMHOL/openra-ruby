## Unreleased

[Compare v1.8.0...HEAD](https://github.com/AMHOL/openra-ruby/compare/v1.8.0...HEAD)

## v1.8.0

### Added

* [replay-data] Add support_powers with usage counts to output

[Compare v1.7.0...v1.8.0](https://github.com/AMHOL/openra-ruby/compare/v1.7.0...v1.8.0)

## v1.7.0

### Improvements

* [core] Decreased memory usage by streaming orders with iterator ([AMHOL](https://github.com/AMHOL))

[Compare v1.6.0...v1.7.0](https://github.com/AMHOL/openra-ruby/compare/v1.6.0...v1.7.0)

## v1.6.0

### Fixed

* [core] Updated to work with release-20200202 (current release) ([AMHOL](https://github.com/AMHOL))

[Compare v1.5.0...v1.6.0](https://github.com/AMHOL/openra-ruby/compare/v1.5.0...v1.6.0)

## v1.5.0

### Added

* [detect-production-macros] A new command to detect production macros ([AMHOL](https://github.com/AMHOL))

### Fixed

* [core] Fix error when sync info does not exactly precede the start game order ([AMHOL](https://github.com/AMHOL))

[Compare v1.4.0...v1.5.0](https://github.com/AMHOL/openra-ruby/compare/v1.4.0...v1.5.0)

## v1.4.0

### Fixed

* [replay-data] Output timestamps in ISO8601 (thanks to [dragunoff](https://github.com/dragunoff)) ([AMHOL](https://github.com/AMHOL))

[Compare v1.3.0...v1.4.0](https://github.com/AMHOL/openra-ruby/compare/v1.3.0...v1.4.0)

## v1.3.0

### Fixed

* [replay-data] Fix client IP by making it omittable ([AMHOL](https://github.com/AMHOL))
* [replay-data] utf8 encode chat names ([AMHOL](https://github.com/AMHOL))

[Compare v1.2.0...v1.3.0](https://github.com/AMHOL/openra-ruby/compare/v1.2.0...v1.3.0)

## v1.2.0

### Fixed

* [replay-data] Use SyncLobbyClients to get chat names ([AMHOL](https://github.com/AMHOL))
* [replay-data] Make client IP optional in client struct (fixes parsing replays with bots) ([AMHOL](https://github.com/AMHOL))

[Compare v1.1.0...v1.2.0](https://github.com/AMHOL/openra-ruby/compare/v1.1.0...v1.2.0)

## v1.1.0

### Fixed

* [replay-data] Make chat messages show name at time of message ([AMHOL](https://github.com/AMHOL))
* [replay-data] Only include clients present at game start ([AMHOL](https://github.com/AMHOL))

[Compare v1.0.1...v1.1.0](https://github.com/AMHOL/openra-ruby/compare/v1.0.1...v1.1.0)

## v1.0.1

### Fixed

* [core] Add bundler as a runtime dependency (thanks to [dragunoff](https://github.com/dragunoff)) ([AMHOL](https://github.com/AMHOL))
* [replay-data] Fixed the game "type" field (by updating it to use players rather than clients array) ([AMHOL](https://github.com/AMHOL))

[Compare v1.0.0...v1.0.1](https://github.com/AMHOL/openra-ruby/compare/v1.0.0...v1.0.1)

## v1.0.0

### Added

* [core] Clean up internals with structs and better abstractions ([AMHOL](https://github.com/AMHOL))
* [replay-data] Added duration struct to game output (formatted/msec) ([AMHOL](https://github.com/AMHOL))
* [replay-data] Added support for YAML output format ([AMHOL](https://github.com/AMHOL))

### Removed

* [replay-data] Removed duration (seconds) field from game output ([AMHOL](https://github.com/AMHOL))

[Compare v0.3.0...v1.0.0](https://github.com/AMHOL/openra-ruby/compare/v0.3.0...v1.0.0)

## v0.3.0

### Fixed

* [replay-data] Fix "type" output when no teams set ([AMHOL](https://github.com/AMHOL))
* [replay-data] Fix error uninitialized constant Openra::CLI::Commands::ReplayData::SecureRandom ([AMHOL](https://github.com/AMHOL))

[Compare v0.2.0...v0.3.0](https://github.com/AMHOL/openra-ruby/compare/v0.2.0...v0.3.0)

## v0.2.0

### Added

* [replay-data] Show chosen and actual faction ([AMHOL](https://github.com/AMHOL))
* [replay-data] Add spawn point info

### Fixed

* [replay-data] Fetch team from replay metadata players hash ([AMHOL](https://github.com/AMHOL))

[Compare v0.1.0...v0.2.0](https://github.com/AMHOL/openra-ruby/compare/v0.1.0...v0.2.0)

## v0.1.0

### Added

* Include server and team chat messages in replay data ([AMHOL](https://github.com/AMHOL))
* Include is_winner replay data client output ([AMHOL](https://github.com/AMHOL))

### Fixed

* Return `null` for client team in replay data when team is not set ([AMHOL](https://github.com/AMHOL))

[Compare v0.0.5...v0.1.0](https://github.com/AMHOL/openra-ruby/compare/v0.0.5...v0.1.0)
