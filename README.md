---
title: OpenSecrets API
emoji: 📊
colorFrom: blue
colorTo: purple
sdk: docker
app_port: 7860
---

# OpenSecrets API

This API serves data derived from the OpenSecrets lobbying SQLite database.

## Endpoints

### GET /
Returns a status message and lists available endpoints.

### GET /lobbyists?year=2016
Returns the number of unique lobbyists for a given year from 1998 to 2018.

### GET /timeseries
Returns the full yearly time series of unique lobbyist counts.

### GET /search?name=SMITH
Returns matching lobbyists whose names contain the search term.

## Example requests

- `/`
- `/lobbyists?year=2016`
- `/timeseries`
- `/search?name=SMITH`

## Data source
This project uses the `lobbyists` table from `data/opensecretslobbying.sqlite`.