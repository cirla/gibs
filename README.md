# GIBS

GNU Internet Backgammon Server

## Why

[FIBS](http://fibs.com/) no longer seems to support [CLIP](http://fibscompanion.sourceforge.net/fibs_interface.html) and is a single point of failure.
This project is an attempt to make it easy for anyone to host a backgammon server and community.

## Goals

- [GnuBG](http://www.gnubg.org/) backend for games
- WebSocket-based protocol for ease of implementing web and native clients
- Included web UI
- Basic chat system (public lobby, private whispers)
- Elo rating system

## Endpoints

- `/` - redirect to `/static/index.html` (built-in web ui)
- `/login` - login and receive JWT for use authorizing with websocket
- `/ws` - websocket endpoint for [the protocol](docs/protocol.md)
