const express = require("express");
const request = require("request");
const app = express();

// Base brawlstars API
const BASE = "https://api.brawlstars.com/v1/";
const API_TOKEN =
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjdjN2JjNTcwLTcxM2UtNDE5NC05YmQ5LWQ3MzA3ZTVkNTdmNiIsImlhdCI6MTU4NTc1NzU1OCwic3ViIjoiZGV2ZWxvcGVyL2IxNjczNTA3LTFiYjYtMGM4NS1kNjU1LTlhZmY2N2I0OWZhZCIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiNTAuOTAuMjEzLjczIl0sInR5cGUiOiJjbGllbnQifV19.Fct4ygWI9EC_qvxp_haEKHF_QVgE2nBHdsyCXzpsuqDRX7ijd5F-tZulP892F99dykuK78auL8JCKoXi1UQN7w";

const PORT = process.env.PORT || 3000;

app.get("/hello", function(req, res) {
  res.send("Hello World");
});

/*
 * This request expects playerTag to be a series of character and numbers.
 * playerTag should not start with a '#'. The '#' will be added in the function
 */

app.get("/players/:playerTag", function(req, res) {
  let params = req.params;
  let playerTag = params.playerTag;

  console.log("playerTag: " + playerTag);
  // res.send(playerTag);
  // console.log(header);
  console.log(BASE + "players/%23" + playerTag);
  request.get(
    BASE + "players/%23" + playerTag,
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      // console.log(res);
      //console.log("MAde it");
      console.log(body);
      res.send(body);
    }
  );
});

/*
 * This request expects playerTag to be a series of character and numbers.
 * playerTag should not start with a '#'. The '#' will be added in the function
 */

app.get("/players/:playerTag/battlelog", function(req, res) {
  let params = req.params;
  let playerTag = params.playerTag;

  request.get(
    BASE + "players/%23" + playerTag + "/battlelog",
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      res.send(body);
    }
  );
});

/*
 * This endpoint expects countryCode to be a 2 character country code or 'global' for global rankings
 *
 * ex: /rankings/us/players will give rankings for all United States Players
 *
 * For other country codes please see:
 * https://www.iban.com/country-codes
 *
 */

app.get("/rankings/:countryCode/players", function(req, res) {
  let params = req.params;
  let countryCode = params.countryCode;
  request.get(
    BASE + "rankings/" + countryCode + "/players",
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      res.send(body);
    }
  );
});

/*
 * This endpoint expects countryCode to be a 2 character country code or 'global' for global rankings
 *
 * ex: /rankings/us/players will give rankings for all United States Players
 *
 * For other country codes please see:
 * https://www.iban.com/country-codes
 *
 */

app.get("/rankings/:countryCode/clubs", function(req, res) {
  let params = req.params;
  let countryCode = params.countryCode;
  request.get(
    BASE + "rankings/" + countryCode + "/clubs",
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      res.send(body);
    }
  );
});

app.get("/brawlers", function(req, res) {
  request.get(
    BASE + "brawlers",
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      res.send(body);
    }
  );
});

app.get("/brawlers/:brawlerId", function(req, res) {
  let params = req.params;
  let brawlerId = params.brawlerId;
  request.get(
    BASE + "brawlers/" + brawlerId,
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json"
      }
    },
    (err, response, body) => {
      if (err) {
        console.log(err);
      }
      res.send(body);
    }
  );
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}...`);
});
