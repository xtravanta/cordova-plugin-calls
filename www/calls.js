module.exports = {
    callListener: function (success, fail) {
        cordova.exec(success, fail, "Calls", "callListener", []);
    }
};