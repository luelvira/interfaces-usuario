// define some vars
  let img = document.querySelector("img");
  let routes = ["https://recetasdecocina.elmundo.es/wp-content/uploads/2023/09/patatas-fritas-perfectas.jpg", "https://www.divinacocina.es/wp-content/uploads/2022/03/filetes-empanados-1.jpg.webp"];
  let pos = 1;
//define a simple function to change the src
  function changes() {
      pos = ++pos%2;
      img.setAttribute("src", routes[pos]);
      console.log("The current value is " + img.getAttribute("src"));
  }

// Select the button by the ID and add the event onclick
let changeMe = document.getElementById("changeMe");
changeMe.addEventListener("click", changes);

let paragraph = document.querySelector("p");
let answer = document.getElementById("answer");
let texts = ["Beth"];

answer.addEventListener("click", function(e) {
    if (typeof(answer.dataset.isShow) === "undefined") { 
        texts.push(paragraph.innerText); // insert the text of the paragraph as a new entry in the array
        answer.dataset.isShow = 0;
    } 
    paragraph.innerText = texts[answer.dataset.isShow++];
    answer.dataset.isShow %= 2;
});

function appendWeirdText() {
    let numberOfSections = 3,
        numberOfArticles = 4,
        numberOfParagraphs = 12;

    for (let i = 0; i < numberOfSections; ++i) {
        const section = document.createElement("section");
        const title = document.createElement("h2");
        title.innerText = "Soy la sección " + i;
        section.appendChild(title);
        for (let j = 0; j < numberOfArticles; ++j) {
            const article = document.createElement("article");
            const subtitle = document.createElement("h3");
            subtitle.innerText = "Soy el artículo " + j + " en la sección " + i;
            article.appendChild(subtitle);
            for (let k = 0; k < numberOfParagraphs; ++k) {
                const paragraph = document.createElement("p");
                paragraph.innerText = "Soy el parrafo " + k + " en el artículo " + j + " y la sección " + i;
                article.appendChild(paragraph);
            }
            // When the article wont be updated more, add it to the section
            section.appendChild(article);
        }
        document.body.insertBefore(section, document.getElementsByTagName("script")[0]);
    }
  }

const newButton = document.createElement("button");
newButton.innerText = "Insert random text";
newButton.addEventListener("click", appendWeirdText);
document.body.insertBefore(newButton, document.getElementsByTagName("script")[0]);
