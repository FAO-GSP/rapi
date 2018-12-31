# rapi

A simple R API for SiSINTA and SISLAC.

## Setup

Running R on this project's directory should load and initialize **packrat**,
and it should install iself if missing. Now is possible to install the project
dependencies restoring a previous snapshot with `restore`

```R
packrat::restore()
```

## Usage

Run the server in development mode with

    R --no-save < server.R
