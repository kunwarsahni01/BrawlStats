const express = require("express");
const request = require("request");
const app = express();

// Base brawlstars API
const BASE = "https://api.brawlstars.com/v1/";
const API_TOKEN =
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjdjN2JjNTcwLTcxM2UtNDE5NC05YmQ5LWQ3MzA3ZTVkNTdmNiIsImlhdCI6MTU4NTc1NzU1OCwic3ViIjoiZGV2ZWxvcGVyL2IxNjczNTA3LTFiYjYtMGM4NS1kNjU1LTlhZmY2N2I0OWZhZCIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiNTAuOTAuMjEzLjczIl0sInR5cGUiOiJjbGllbnQifV19.Fct4ygWI9EC_qvxp_haEKHF_QVgE2nBHdsyCXzpsuqDRX7ijd5F-tZulP892F99dykuK78auL8JCKoXi1UQN7w";

const header = {
  Accept: "application/json"
};

app.get("/hello", function(req, res) {
  res.send("Hello World");
});

app.get("/player/:playerTag", function(req, res) {
  let params = req.params;
  let playerTag = params.playerTag;

  console.log("playerTag: " + playerTag);
  res.send(playerTag);
  // console.log(header);

  // Need to remove #, if it exists, and replace it with a %23
  // Not doing this will cause the call to fail
  request(
    BASE + "player/" + playerTag,
    {
      auth: {
        bearer: API_TOKEN
      },
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    },
    (err, res, body) => {
      if (err) {
        console.log(err);
      }
      console.log(res);
      //console.log("MAde it");
      console.log(body);
    }
  );
});

app.listen(3000);
