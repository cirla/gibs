# Protocol

JSON over WebSocket on `/ws` endpoint.

## Authorization

Authorization is done via a JWT token sent as a URL query param `token`.
This token can be obtained via the `/login` endpoint.

## Envelope

All top-level messages contain a single key which is the type of the contained message, e.g. for `say`:

```json
{
    "say": {
        ...
    }
}
```

## Outgoing

1. `say`: Send a message to the lobby

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

