const genreButton = document.getElementById("genre-menu-icon")
const checkboxContainer = document.getElementById("genre-checkbox-container")

genreButton.addEventListener("click", () => {
    checkboxContainer.classList.toggle("hidden");
})

// https://github.com/bradtraversy/50projects50days/blob/master/hidden-search/script.js
const search = document.querySelector('.search-container');
const btn = document.getElementById('search-icon')
const input = document.getElementById('title-filter');

btn.addEventListener('click', () => {
    search.classList.toggle('active');
    input.focus();
})

// when DOM content is loaded, get and parse the data into the web page
document.addEventListener("DOMContentLoaded", getAndParseGameData)
function getAndParseGameData() {
    const gameList = document.getElementById('game-list-container');
    function getData() {
        // make GET request to server to get JSON of game list data back
        fetch('/data/game-list-data')
            .then((res) => {
                if(!res.ok) {
                    throw new Error('HTTP error: ${response.status}');
                }
                else {
                    return res.json();
                }
            })
            .then(gameListData => parseData(gameListData));
    }

    function parseData(gameListData){
        // loop through the array of games within the object
        for(let i = 0; i < gameListData.games.length; i++) {
            let htmlToAppend =
            `
            <div class="game-container">
                <div class="game-image">
                    <img src="../game-cover-images/covers-200x300/${gameListData.games[i]['img-file-name']}" alt="${gameListData.games[i].name} cover art">                    
                </div>
                <div class="game-info">
                    <span>${gameListData.games[i].name}</span>
                </div>
                <div class="button-and-rating-container">
                    <div class="button-container">
                        <button class="playing-button"
                            data-game-id="${gameListData.games[i].id}" 
                            data-game-name="${gameListData.games[i].name}" 
                            data-img-name="${gameListData.games[i]['img-file-name']}" 
                            data-status="playing">
                            Playing
                        </button>
                        <button class="completed-button" 
                            data-game-id="${gameListData.games[i].id}" 
                            data-game-name="${gameListData.games[i].name}" 
                            data-img-name="${gameListData.games[i]['img-file-name']}" 
                            data-status="completed">
                            Completed
                        </button>
                        <button class="planning-button"
                            data-game-id="${gameListData.games[i].id}" 
                            data-game-name="${gameListData.games[i].name}" 
                            data-img-name="${gameListData.games[i]['img-file-name']}" 
                            data-status="planning">
                            Planning
                        </button>
                        <button class="remove-button hide" data-game-id="${gameListData.games[i].id}">Remove from List</button>
                    </div>
                    <div class="rating-container hide">
                        <label>
                            Rating
                            <input type="text" class="rating-field" data-game-id="${gameListData.games[i].id}" placeholder=".../5">
                        </label>
                        <span class="error-text"></span>
                    </div>
                </div>
            </div>
            `
            gameList.insertAdjacentHTML('beforeend', htmlToAppend);
        }
        configureUI();
        addGameContainerListeners();
        applyScrollAnimation(document.querySelectorAll('.game-container'));
    }
    function configureUI() {
        // make GET request to server to get JSON of user data back
        fetch('/data/user-data')
        .then((res) => {
            if(!res.ok) {
                throw new Error('HTTP error: ${response.status}');
            }
            else {
                return res.json();
            }
        })
        .then(data => {
            // if the user has data stored
            if(data['data-exists']){
                let gameListContainers = gameList.children;
                const gameData = data.games;
                for(const gameId in gameData) {
                    // get the button and rating box elements
                    const gameListContainerContent = gameListContainers[parseInt(gameId) - 1].children
                    const gameListButtonsAndRatingContainer = gameListContainerContent[2].children;
                    const buttons = gameListButtonsAndRatingContainer[0].children;
                    const ratingBox = gameListButtonsAndRatingContainer[1];
                    let gameStatus = gameData[gameId].status;
                    // check what current status is, hide or show rating boxes and buttons as needed
                    if(gameStatus === 'playing'){
                        addOrHideButton(buttons, 0);
                        hideElement(ratingBox, false);
                    }
                    else if(gameStatus === 'completed'){
                        addOrHideButton(buttons, 1);
                        hideElement(ratingBox, false);
                    }
                    else if(gameStatus === 'planning'){
                        addOrHideButton(buttons, 1);
                    }
                }
            }
        });
    }

    // call getData() to begin the process of getting data then parsing it and then configuring the UI
    getData()
}

function addGameContainerListeners(){
    function addRatingBoxListeners(){
        const ratingBoxes = document.querySelectorAll('.rating-field');
        ratingBoxes.forEach(ratingBox => {
            ratingBox.addEventListener('keydown', (e) => {
                // clear any error text on input
                let errorPrompt = e.target.parentNode.nextElementSibling;
                errorPrompt.innerText = '';
                if(e.key === 'Enter'){
                    // check if input is not a number between 0-5, and output an error if that is the case
                    if(!e.target.value.match(/^\d+(.\d+)?$/) || parseFloat(e.target.value) < 0 || parseFloat(e.target.value) > 5) {
                        errorPrompt.innerText = 'Input a number beween 0-5';
                    }
                    else {
                        // make PUT request to update JSON in the server
                        fetch('/data/add-user-review', {
                            method: 'PUT',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({
                                data: {
                                        'game-id' : e.target.dataset.gameId,
                                        'review' : e.target.value
                                }
                            })
                        });
                        // clear rating input box on successful submisson
                        e.target.value = '';
                    }
                }
            })
        })
    }
    function addButtonListeners(){
        function addPlayingButtonListeners(){
            const playingButtons = document.querySelectorAll('.playing-button');
            playingButtons.forEach(playingButton => {
                playingButton.addEventListener('click', (e) => {
                    const siblingsList = e.target.parentNode.children;
                    let ownChildIdx = 0;
                    // hide its own button and show the other buttons and the rating box
                    addOrHideButton(siblingsList, ownChildIdx)
                    hideElement(e.target.parentNode.nextElementSibling, false);
                    sendButtonData(e.target);
                })
            })
        }
        function addCompletedButtonListeners(){
            const completedButtons = document.querySelectorAll('.completed-button');
            completedButtons.forEach(completedButton => {
                completedButton.addEventListener('click', (e) => {
                    const siblingsList = e.target.parentNode.children;
                    let ownChildIdx = 1;
                    // hide its own button and show the other buttons and the rating box
                    addOrHideButton(siblingsList, ownChildIdx);
                    hideElement(e.target.parentNode.nextElementSibling, false);
                    sendButtonData(e.target);
                })
            })
        }
        function addPlanningButtonListeners(){
            const planningButtons = document.querySelectorAll(`.planning-button`);
            planningButtons.forEach(planningButton => {
                planningButton.addEventListener('click', (e) => {
                    const siblingsList = e.target.parentNode.children;
                    let ownChildIdx = 2;
                    // hide its own button and the rating box and show the other buttons
                    addOrHideButton(siblingsList, ownChildIdx);
                    hideElement(e.target.parentNode.nextElementSibling);
                    sendButtonData(e.target);
                })
            })
        }
        function addRemoveButtonListeners(){
            const removeButtons = document.querySelectorAll('.remove-button');
            removeButtons.forEach(removeButton => {
                removeButton.addEventListener('click', (e) => {
                    let siblingsList = e.target.parentNode.children;
                    let ownChildIdx = 3;
                    // hide its own button and the rating box and show the other buttons
                    addOrHideButton(siblingsList, ownChildIdx)
                    hideElement(e.target.parentNode.nextElementSibling);
                    // make PUT request to update JSON in the server
                    fetch('/data/remove-user-data', {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            data: {
                                    'game-id' : e.target.dataset.gameId
                            }
                        })
                    });
                })
            })
        }
        function addSearchBarListener(){
            // https://github.com/bradtraversy/50projects50days/blob/master/live-user-filter/script.js
            const listItems = document.querySelectorAll('.game-info > span');
            const filter = document.getElementById('title-filter');
            filter.addEventListener('input', (e) => {
                listItems.forEach(item => {
                    if(item.innerText.toLowerCase().includes(e.target.value.toLowerCase())) {
                        item.parentNode.parentNode.classList.remove('hide')
                    } else {
                        item.parentNode.parentNode.classList.add('hide')
                    }
                })
            })
        }
        addPlayingButtonListeners();
        addCompletedButtonListeners();
        addPlanningButtonListeners();
        addRemoveButtonListeners();
        addSearchBarListener();
    }
    addRatingBoxListeners();
    addButtonListeners();
}

function addOrHideButton(buttonList, ownBtnIndex) {
    // loop through all buttons in list, hide button if it is itself, otherwise show the button
    for(let i = 0; i < buttonList.length; i++){
        i === ownBtnIndex ? hideElement(buttonList[i]) : hideElement(buttonList[i], false);
    }
}

function hideElement(ele, hideFlag=true) {
    // if flag true, hide element, else show element
    hideFlag ? ele.classList.add('hide') : ele.classList.remove('hide');
}

function sendButtonData(btn) {
    // https://stackoverflow.com/questions/4295782/how-to-process-post-data-in-node-js
    // https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch

    // make PUT request to update JSON in the server (for user profile)
    fetch('/data/add-user-data', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            data: {
                    'game-id' : btn.dataset.gameId,
                    'name' : btn.dataset.gameName,
                    'img-file-name' : btn.dataset.imgName,
                    'status' : btn.dataset.status
            }
        })
    });
    // make PUT request to update JSON in the server (for feed page)
    fetch('/data/add-feed-data', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            data: {
                    'name' : btn.dataset.gameName,
                    'img-file-name' : btn.dataset.imgName,
                    'status' : btn.dataset.status
            }
        })
    });
}