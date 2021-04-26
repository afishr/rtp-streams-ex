# RTP Course. Spring 2021.

**Streaming Twitter sentiment analysis system**

## Description

Application fetches streams from 2 endpoints and through __Router__ redirect them to __Analyzers__ of sentiments & engagement scores in parallel. After that computed data in directed to __Aggregator__ where it is combined by unique tweet ID and saved in __Database__

## Running

1. Run docker containers with `$ docker-compose up -d`
1. Install dependencies with `$ mix deps.get`
1. Run application with `$ mix run`
1. Watch the changes in terminal and database instance that was opened on address `mongodb://localhost:27013`

## Dataflow Scheme

![dataflow](.github/dataflow.png "Dataflow")

## Demo

![demo](.github/demo.gif "Demo")