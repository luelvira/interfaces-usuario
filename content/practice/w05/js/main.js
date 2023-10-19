let form = document.getElementsByTagName("form")[0];
form.addEventListener("submit", function(e) {
    // check which was the triger
    let self = e.currentTarget;
    console.log(self);
    // get the elements value
    let keys = [1, 2, 3].map(n => "field" + n);
    console.log(keys);
    let values = keys.map(n => self[n].value);
    console.log(values);

    e.preventDefault();
    e.stopPropagation();
});
