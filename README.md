# OpenRA Rubygem [WIP]

### Current state
Can read immediate orders and very hacky

### Example usage

```ruby
# Checkout the repo
# bundle install
# bin/console
replay_filename = '/path/to/replay.orarep'
replay = OpenRA::Replays::File.new(replay_filename)
packets = replay.packets.packets

packets.select(&:valid_order_list?).map do |order_list|
  # Rescue nil as we can't read standard orders
  OpenRA::Replays::Order.read(order_list.data[4..-1]) rescue nil
end
# => [
#   {
#     :identifier=>"\xFE",
#     :command=>"HandshakeRequest",
#     :target=>"Handshake:\n\tMod: ra\n\tVersion: release-20180307\n\tMap: f6828d09e504c5294087261d9928efba86015b40\n"
#   },
#   ...
# ]
```
