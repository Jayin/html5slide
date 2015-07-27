// Find the right method, call on correct element
window.launchIntoFullscreen = function (element) {
  if(element.requestFullscreen) {
    element.requestFullscreen();
  } else if(element.mozRequestFullScreen) {
    element.mozRequestFullScreen();
  } else if(element.webkitRequestFullscreen) {
    element.webkitRequestFullscreen();
  } else if(element.msRequestFullscreen) {
    element.msRequestFullscreen();
  }
}

// Launch fullscreen for browsers that support it!
// launchIntoFullscreen(document.documentElement); // the whole page
// launchIntoFullscreen(document.getElementById("videoElement")); // any individual element
