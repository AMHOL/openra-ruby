# OpenRA Rubygem

### Current state
Can read both standard and immediate orders, very early WIP

### Example usage

```ruby
# Checkout the repo
# bundle install
# bin/console
replay_filename = '/path/to/replay.orarep'
replay = OpenRA::Replays::Replay.new(replay_filename)
replay.metadata
replay.orders
# => [
#   {
#     :order_type=>"\xFE",
#     :command=>"HandshakeRequest",
#     :target=>"Handshake:\n\tMod: ra\n\tVersion: release-20180307\n\tMap: f6828d09e504c5294087261d9928efba86015b40\n"
#   },
#   ...
# ]
```
