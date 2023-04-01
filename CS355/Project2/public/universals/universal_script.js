// https://github.com/bradtraversy/50projects50days/blob/master/scroll-animation/script.js
// create function in global scope for other scripts to use for their web page
function applyScrollAnimation(listOfBoxes) {
    // triggers whenever user scrolls or inputs to search (so that hidden things appear if now in range post-search)
    window.addEventListener('scroll', checkBoxes);
    window.addEventListener('input', checkBoxes);
    function checkBoxes() {
        const triggerBottom = window.innerHeight / 5 * 4;
        listOfBoxes.forEach(box => {
            const boxTop = box.getBoundingClientRect().top;
            if(boxTop < triggerBottom) {
                box.classList.add('show');
            }
            else {
                box.classList.remove('show');
            }
        })
    }
    checkBoxes();
}