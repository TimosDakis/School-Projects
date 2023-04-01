// set up connection, serve HTML, etc. files
const express = require('express');
const fs = require('fs');
const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.listen(PORT, () => {console.log('Running on Port: '+ PORT)});

// all gets just send JSON to clients when relevant
app.get('/data/user-data', (req, res) => {
    fs.readFile('data/user-data.json', (err, data) => {
        if(err) throw err;
        let userData = JSON.parse(data);
        res.json(userData);
    })
})

app.get('/data/game-list-data', (req, res) => {
    fs.readFile('data/game-list.json', (err, data) => {
        if(err) throw err;
        let gameListData = JSON.parse(data);
        res.json(gameListData);
    })
})

app.get('/data/feed-data', (req, res) => {
    fs.readFile('data/feed-data.json', (err, data) => {
        if(err) throw err;
        let feedData = JSON.parse(data);
        res.json(feedData);
    })
})

// https://stackoverflow.com/questions/4295782/how-to-process-post-data-in-node-js
app.put('/data/add-user-data', (req, res) => {
    let dataFileName = `data/user-data.json`;
    fs.readFile(dataFileName, (err, data) => {
        if(err) throw err;
        let userData = JSON.parse(data);
        // if there is no data in JSON, create a skeleton to insert data
        if(!userData['data-exists']){
            userData['data-exists'] = true;
            userData['num-playing'] = 0;
            userData[`num-completed`] = 0;
            userData['num-planning'] = 0;
            userData.games = {};
        }
        // if game already in profile, decrease counter tracking its current status and just update its status in the JSON to new status
        if(Object.hasOwn(userData.games, req.body.data['game-id'])) {
            userData[`num-${userData.games[req.body.data['game-id']].status}`] -= 1;
            userData.games[req.body.data['game-id']].status = req.body.data.status;
        }
        // otherwise, create a new entry with all relevant info within the JSON
        else {
            userData.games[req.body.data['game-id']] = {
                'img-url': `../game-cover-images/covers-200x300/${req.body.data['img-file-name']}`,
                'name': req.body.data.name,
                'rating': "Not Rated",
                'status': req.body.data.status
            };
        }
        // increase counter tracking the new status of the game
        userData[`num-${req.body.data.status}`] += 1; 
        fs.writeFile(dataFileName, JSON.stringify(userData, null, 4), (err) => {if(err) throw err;});
        // https://stackoverflow.com/questions/9107226/how-to-end-an-express-js-node-post-response
        res.status(204).send();
    })
})

app.put('/data/add-feed-data', (req, res) => {
    let dataFileName = 'data/feed-data.json';
    fs.readFile(dataFileName, (err, data) => {
        if (err) throw err;
        let feedData = JSON.parse(data);
        // insert the object into the array in the JSON, if >30 entries, pop oldest entry from the array
        feedData.feed.unshift(req.body.data)
        if(feedData.feed.length > 30) feedData.feed.pop();
        fs.writeFile(dataFileName, JSON.stringify(feedData, null, 4), (err) => {if(err) throw err;});
        res.status(204).send();
    })
})

app.put('/data/add-user-review', (req, res) => {
    let dataFileName = `data/user-data.json`;
    fs.readFile(dataFileName, (err, data) => {
        if(err) throw err;
        let userData = JSON.parse(data);
        // update rating field of the game within the JSON to the rating in 2 decimal places
        userData.games[req.body.data['game-id']].rating = (parseFloat(req.body.data.review).toFixed(2) + ' / 5.00');
        fs.writeFile(dataFileName, JSON.stringify(userData, null, 4), (err) => {if(err) throw err;});
        res.status(204).send();
    })
})

app.put('/data/remove-user-data', (req, res) => {
    let dataFileName = `data/user-data.json`;
    fs.readFile(dataFileName, (err, data) => {
        if(err) throw err;
        let userData = JSON.parse(data);
        // decrease counter of game's current status, and then remove the game entry from the JSON
        userData[`num-${userData.games[req.body.data['game-id']].status}`] -= 1
        delete userData.games[req.body.data['game-id']]

        // https://stackoverflow.com/questions/2673121/how-to-check-if-object-has-any-properties-in-javascript
        if(!Object.keys(userData.games).length){
            userData = { 'data-exists' : false }
        }
        fs.writeFile(dataFileName, JSON.stringify(userData, null, 4), (err) => {if(err) throw err;});
        res.status(204).send();
    })
})