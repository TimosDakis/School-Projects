function startCarousel(){
    // https://github.com/bradtraversy/50projects50days/blob/master/image-carousel/script.js
    const imgs = document.getElementById('imgs')
    const img = document.querySelectorAll('#imgs img')

    let idx = 0

    let interval = setInterval(iterateCarousel, 2000)

    function iterateCarousel() {
        idx++
        changeImage()
    }

    function changeImage() {
        if(idx > img.length - 1) {
            idx = 0
        } else if(idx < 0) {
            idx = img.length - 1
        }

        imgs.style.transform = `translateX(${-idx * 200}px)`
    }
}

startCarousel();

function welcomeTextAnimation() {
    // https://github.com/bradtraversy/50projects50days/blob/master/auto-text-effect/script.js
    const textEl = document.getElementById('welcome-text')
    const text = 'Welcome back, <a href="profile-page/profile.html">Timothy</a>!'
    let textIdx = 1

    // determine where all the < and > of the opening and closing anchor tags are
    let AnchorOpenStartIdx = text.indexOf('<');
    let AnchorOpenEndIdx = text.indexOf('>');
    let AnchorCloseStartIdx = text.lastIndexOf('<');
    let AnchorCloseEndIdx = text.lastIndexOf('>');
    let speed = 200;

    writeText()

    function writeText() {
        textEl.innerHTML = (() => {
            // check if index of text has reached on of the opening <, if so set it to the index of the closing >
            textIdx = textIdx === AnchorOpenStartIdx ? AnchorOpenEndIdx + 1 :
                    textIdx === AnchorCloseStartIdx ? AnchorCloseEndIdx + 1 :
                    textIdx;
            return text.slice(0, textIdx);
        })();

        textIdx++;

        if(textIdx <= text.length) {
            setTimeout(writeText, speed);
        }
    }
}

welcomeTextAnimation();