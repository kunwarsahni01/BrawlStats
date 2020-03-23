Group Project
===

# BrawlStat

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
A simple app that tracks the statistics of a user who plays the BrawlStar Game

### App Evaluation
- **Category:** Game
- **Mobile:** iOS
- **Story:** BrawlStars is a mobile game that is played by millions around the world, there is currently no way to view BrawlStars stats through a mobile app. This app will show a users personal stats and other users stats as well.
- **Market:** BrawlStars players
- **Habit:** Active player will constantly check for their stats
- **Scope:** All players

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Show User Stats
* Trophy Graph
* Show Global Stats: Top Users and Top Clubs
* Search other people's stat

**Optional Nice-to-have Stories**

* Club stats
* Club member changes over time

### 2. Screen Archetypes

* Profile
   * Show User Stats
   * Trophy Graph
* Search (Search User Tag)
    * Login
* Stream
    * Search other people's stat

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Personal Stats
* Search
* Global Rankings

**Flow Navigation** (Screen to Screen)

* Personal Stat
* Search
   => User Stats
   => Personal Stats
* Global Stats
   => User Stats


## Wireframes
<img src="https://imgur.com/8QAaVzP.png" width=600>


## Schema 

### Models

#### Player
| Property      | Type     | Description |
|---------------|----------|-------------|
|tag|String|A unique tag, provided from brawlstars for each player of the game
| ourRank | Number | [Optional] if API doesn't provide Ranking this will be a ranking with respect to our users
| brawlstarsRank | Number | Global Ranking of Player |

#### Match
| Property      | Type     | Description |
|---------------|----------|-------------|
| trophiesEarned | Number | The number of trophies gained or lost during a match
| battleTime | Number | The time the battle happened
| event | Event | The details about the match

#### Event
| Property      | Type     | Description |
|---------------|----------|-------------|
| map | String | the map that the was played
| id | String | the type of Game that was played |

### Networking
#### List of network requests by screen
Our application does not use any requests other than API requests from Brawlstars API

#### API Endpoints
Base URL - 

HTTP Verb | Endpoint | Description
----------|----------|------------
GET | /players/{playerTag} | Get information about a single player by player tag. Player tags can be found either in game or by from clan member list.
GET | /players/{playerTag}/battleLog | Get list of recent battle results for a player.
GET | /rankings/{countryCode}/players | Get player rankings for a country or global rankings.
GET | /rankings/{countryCode}/brawlers/{brawlerId} | Get brawler rankings for a country or global rankings. Brawler identifiers can be found by using the /v1/brawlers API endpoint. 
GET |/brawlers | Get list of available brawlers.
GET |/brawlers/{brawlerId} | Get information about a brawler.


