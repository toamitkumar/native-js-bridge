var NativeJSBridge = {
  callBacksCount: 1,
  callbacks: {},

  // Called from native layer automatically when a result is available - aysnc
  callBackResult: function callBackResult(callBackId, result) {
    try {
      var callback = NativeJSBridge.callbacks[callBackId];
      if (!callback) {
        return;
      }
      callback(result);

    } catch(e) {
      alert(e);
    }
  },

  call: function call(functionName, args, callback) {
    var hasCallback = callback && typeof(callback == "function");
    var callBackId = hasCallback ? NativeJSBridge.callBacksCount++ : 0;

    if(hasCallback) {
      NativeJSBridge.callbacks[callBackId] = callback;
    }

    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", "js-bridge-frame::" + functionName + "::" + callBackId+ "::" + encodeURIComponent(JSON.stringify(args)));
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  }
};