# RTP Course. Spring 2021.

**Streaming Twitter sentiment analysis system**

## Description

Application fetches streams from 2 endpoints and through __Router__ redirect them to __Analyzers__ of sentiments & engagement scores in parallel. After that computed data in directed to __Aggregator__ where it is combined by unique tweet ID and saved in __Database__ and sending tweets to __Message Broker__ on topic _tweeter_

## Running

1. Run docker containers with `$ docker-compose up -d`
1. Connect to message broker through _netcat_ on port 6666
1. Subscribe to topic _tweeter_ to receive tweets from __Analyzer__

## Demo

[![Video Demo](https://img.youtube.com/vi/pKNLIWEWp_M/0.jpg)](https://www.youtube.com/watch?v=pKNLIWEWp_M)