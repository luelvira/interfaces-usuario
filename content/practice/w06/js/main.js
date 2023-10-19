function MyLocalStorage() {
    this.myStorage = {};
};
let myLocalStorage = new MyLocalStorage();

MyLocalStorage.prototype.getItem = function(key, defaultValue) {
    // Check if we have the item
    if (this.myStorage[key]) return this.myStorage[key];
    this.myStorage = Object.fromEntries(
        document.cookie.split("; ") // return the first array
            .map(cookie => cookie.split("=")) // convert the array into the matrix
        );
    return this.myStorage[key] || defaultValue;
};

MyLocalStorage.prototype.setItem = function(key, value) {
      this.myStorage[key] = value;
      document.cookie = `${key}=${value}`;
};

MyLocalStorage.prototype.removeItem = function(key) {
    let date = new Date(0);
    date = date.toUTCString();
      document.cookie = `${key}=null;expires=${date}`;
      delete myLocalStorage[key];
};

MyLocalStorage.prototype.clear = function() {
    for (let key of Object.keys(this.myStorage))
        this.removeItem(key);
};

function MyLocalStorage2() {
    const update = () => Object.fromEntries(document.cookie.split("; ").map(s => s.split("=")));
    let myStorage = update();
    this.getItem = function(key, defaultValue) {
        if (key in myStorage) return myStorage[key];
        myStorage = update();
        return myStorage[key] || defaultValue;
    };

    this.setItem = function(key, value) {
        myStorage[key] = value;
        document.cookie = `${key}=${value}`;
    };

    this.removeItem = function(key) {
        let date = new Date(0);
        date.toUTCString();
        document.cookie = `${key}=null;expires=${date}`;
        delete myLocalStorage[key];
    }
    this.clear = function() {
        for (let key of Object.keys(myStorage)) {
            this.removeItem(key);
        }
    }
};

let myLocalStorage2 = new MyLocalStorage2();

const cookiesOperations = {
    listOfCookies: Object.fromEntries(document.cookie.split("; ").map(co => co.split("="))),

    setItem(key, value) {
        this.listOfCookies[key] = value;
        document.cookie = `${key}=${value}`;
    },

    getItem(key, defaultValue) {
        // return this.listOfCookies[key] if this.listOfCookies[key] else defaultValue
        return this.listOfCookies[key] ? this.listOfCookies[key] : defaultValue;
    },

    remove(key) {
        delete this.listOfCookies[key];
        document.cookie = `${key}=null; expires=${(() => new Date(0))().toUTCString()}`;
    },

    clear() {
        for (let key in this.listOfCookies)
             this.remove(key);
    },
}
