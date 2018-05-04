#  Bitfinex Websockets
## Some general info and notes


#### Heartbeating
If there is no activity in the channel for 5 second, Websocket server will send you an heartbeat message in this format.

```[ CHANNEL_ID, "hb" ]```

