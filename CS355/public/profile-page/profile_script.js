// https://github.com/bradtraversy/50projects50days/blob/master/incrementing-counter/script.js
function beginIncrementingCounters() {
    const counters = document.querySelectorAll('.counter')
    counters.forEach(counter => {
        counter.innerText = '0'

        const updateCounter = () => {
            const target = +counter.getAttribute('data-target')
            const c = +counter.innerText

            const increment = target / 10

            if(c < target) {
                counter.innerText = `${(c + increment).toFixed(2)}`
                setTimeout(updateCounter, 55)
            } else {
                counter.innerText = target
            }
        }
        updateCounter()
    })
}

document.addEventListener("DOMContentLoaded", getAndParseUserData);
function getAndParseUserData() {
    // make GET request to server to get JSON of user data back
    function getData() {
        fetch('/data/user-data')
            .then((res) => {
                if(!res.ok) {
                    throw new Error('HTTP error: ${response.status}');
                }
                else {
                    return res.json();
                }
            })
            .then(data => parseData(data));
    }

    function parseData(data) {
        // if data exists, then parse the data
        if(data['data-exists']) {
            // add relevant data to user stats counters, then start the visual incrementing
            document.getElementById('playing-data').dataset.target = data['num-playing'];
            document.getElementById('complete-data').dataset.target = data['num-completed'];
            document.getElementById('planning-data').dataset.target = data['num-planning'];
            beginIncrementingCounters();

            // get relevant DOM elements
            const PlayingTable = document.getElementById('playing-table');
            const CompletedTable = document.getElementById('completed-table');
            const PlanningTable = document.getElementById('planning-table');

            // add each game to the relevant table
            const gameData = data.games;
            for(const gameId in gameData) {
                let htmlToAppend = 
                    `
                    <tr>
                        <td><img src="${gameData[gameId]['img-url']}" alt="${gameData[gameId].name} cover art"></td>
                        <td>${gameData[gameId]['name']}</td>
                        <td>${gameData[gameId]['rating']}</td>
                    </tr>
                    `
                // pick which table to append data to
                let tableToAppendTo = gameData[gameId]['status'] === 'playing' ? PlayingTable :
                    gameData[gameId]['status'] === 'completed' ? CompletedTable : PlanningTable;
                tableToAppendTo.insertAdjacentHTML('afterbegin', htmlToAppend);
            }
        }
        // if no data exists, add a prompt leading them to the game list so they can start tracking
        else {
            let htmlToAppend = 
            `
            <div class="no-data-prompt">
                It looks like your profile is empty<br>
                Check out the <a href="../game-list-page/game-list.html">Game List</a> to add some games!
            </div>
            `
            document.querySelector('.main-page-content').innerHTML = htmlToAppend;
        }
    }

    // call getData() to begin the process of getting data then parsing it
    getData();

}