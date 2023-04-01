document.addEventListener("DOMContentLoaded", getAndParseFeedData);
function getAndParseFeedData() {
    // make GET request to server to get JSON of feed data back
    function getData() {
        fetch('/data/feed-data')
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
        // check if the user's feed is empty
        if(data.feed.length > 0) {
            const userFeed = document.getElementById('feed-container')
            data.feed.forEach(feedInfo => {
                let htmlToAppend =
                `
                <div class="feed-box">
                    <div class="feed-image">
                       <img src="../game-cover-images/covers-200x300/${feedInfo['img-file-name']}" alt="${feedInfo.name} cover art">
                    </div> 
                    <div class="feed-info">
                        <span>Timothy ${feedInfo.status === 'completed' ? 'has' : 'is'} ${feedInfo.status}${feedInfo.status === 'planning' ? ' to play' : ''} ${feedInfo.name}</span>
                    </div>
                </div>
                `
                userFeed.insertAdjacentHTML('beforeend', htmlToAppend);
            });
            applyScrollAnimation(document.querySelectorAll('.feed-box'));
        }
        // if the feed is empty, prompt user to check game list to start tracking games
        else {
            let htmlToAppend = 
            `
            <div class="no-data-prompt">
                It looks like your feed is empty<br>
                Check out the <a href="../game-list-page/game-list.html">Game List</a> to add some games!
            </div>
            `
            document.querySelector('.main-page-content').innerHTML = htmlToAppend;
        }
    }

    // call getData() to begin the process of getting data then parsing it
    getData();

}