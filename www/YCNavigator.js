// YCNavigator
// Author: Yu Chen <yu.chen@live.ie>
// License: Apache License 2.0

'use strict';

module.exports = {
  /**
   * @param {object|string} options
   * @param {Function} successCallback ['success']
   * @param {Function} errorCallback ['fail'|'cancel'|'invalid']
   */
  open: function (param, successCallback, errorCallback) {
    cordova.exec(null, null, "YCNavigator", "open", [JSON.stringify(param)]);
  }
};