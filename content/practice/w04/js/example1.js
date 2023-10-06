let paragraph = document.querySelector("p"),
      button = document.querySelector("button"),
      texts = ["Beth"];

button.addEventListener("click", function(e) {
    if (typeof(button.dataset.isShow) === "undefined") { 
        texts.push(paragraph.innerText); // insert the text of the paragraph as a new entry in the array
        button.dataset.isShow = 0;
    } 
    paragraph.innerText = texts[button.dataset.isShow++];
    button.dataset.isShow %= 2;
});
