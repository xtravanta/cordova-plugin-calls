module.exports = {
    callEnded: function (success, fail) {
        cordova.exec(success, fail, "Calls", "callEnded", []);
    }
};