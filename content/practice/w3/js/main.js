let button = document.querySelector("button");
 let paragraph = document.querySelector("p");
 button.addEventListener("click", () => {
!document.fullScreen && paragraph.requestFullscreen() || document.exitFullscreen();
 });
