module.exports = {
    startListener: function (success, fail) {
        cordova.exec(success, fail, "Calls", "startListener", []);
    },
    stopListener: function (success, fail) {
        cordova.exec(success, fail, "Calls", "stopListener", []);
    }
};