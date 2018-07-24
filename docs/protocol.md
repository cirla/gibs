# Protocol

JSON over WebSocket

## Envelope

All top-level messages contain a single key which is the type of the contained message, e.g. for `connect`:

```json
{
    "connect": {
        ...
    }
}
```

## Outgoing

1. `connect`: Connect with an authorized JWT

```json
{
    "token": "abc.def.ghi"
}
```

2. `say`: Send a message to the lobby

```json
{
    "message": "Hello!"
}
```

## Incoming

1. `connected`: A player has connected

```json
{
    "username": "player1"
}
```

2. `disconnected`: A player has disconnected

```json
{
    "username": "player1"
}
```

3. `message`: A player has sent a message to the lobby

```json
{
    "username": "player1",
    "body": "Hello!"
}
```

