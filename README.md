# OpenRA Rubygem

Unofficial gem for [OpenRA](https://openra.net); a free, open-source real-time strategy game engine for early Westwood games such as Command & Conquer: Red Alert written in C#

Currently the only operation implemented by this gem is to parse and extract data from replay files, if this is not what you're looking for, please see the [Other tools](#other-tools) section, perhaps what you need has already been implemented elsewhere.

### Installation
```sh
gem install openra
```

NOTE: Requires Ruby ([Installation guide](https://www.ruby-lang.org/en/documentation/installation/))

### Updating
```sh
gem update openra
```

### Example usage

```sh
openra replay-data /payh/to/replay.orarep [--format json|pretty-json|yaml]
```

### Other tools

* [OpenRA Replay Analytics](https://dragunoff.github.io/OpenRA-replay-analytics/)

A web visualisation tool created by [dragunoff](https://github.com/dragunoff), designed to work with this gem, enter the output from the `replay-data` command with the `json` or `pretty-json` format to see a visualisation of the replay, including game information, clients and build orders.

* [openrareplay gem](https://rubygems.org/gems/openrareplay)

Created by [spanglel](https://github.com/spanglel), a gem designed to strip extraneous data from [OpenRA](https://openra.net) replay files, see the [readme](https://github.com/spanglel/OpenRAReplay) for [installation](https://github.com/spanglel/OpenRAReplay#installation) and [usage](https://github.com/spanglel/OpenRAReplay#usage) instructions.
