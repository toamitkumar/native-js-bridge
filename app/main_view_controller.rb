class MainViewController < UIViewController

  def loadView
    background, webFrame = initializeScreenAndFrame

    @webView = UIWebView.alloc.initWithFrame(webFrame)
    @webView.scalesPageToFit = true
    @webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
    @webView.delegate = self
    @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('ui-webview', ofType:'html'))))
  end
    
  # Only add the web view when the page has finished loading
  # Call the JS function and pass any arg
  def webViewDidFinishLoad(webView)
    self.view.addSubview(@webView)
  end



  # This selector is called when something is loaded in our webview
  # By something I don't mean anything but just "some" :
  #   - main html document
  #   - sub iframes document
  # But all images, xmlhttprequest, css, ... files/requests doesn't generate such events
  def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)

    requestString = inRequest.URL.absoluteString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

    if(requestString.hasPrefix("js-bridge-frame"))
      components = requestString.split("::")
      p components
      functionName, callBackId = components[1], components[2]
      functionArgString = components[3]

      handleJSCall(functionName, callBackId, functionArgString)

      return false
    end
    true
  end  

  def handleJSCall(functionName, callbackId, json)  
    if(functionName == "nameAndLocation")
      outJson = BW::JSON.generate({'name' => 'Amit Kumar', 'location' => 'Mumbai'})
    end

    jsString = format("NativeJSBridge.callBackResult('%d', '%s');", callbackId, outJson.to_s)

    @webView.stringByEvaluatingJavaScriptFromString(jsString)
  end

  def initializeScreenAndFrame
    background = UIColor.lightGrayColor
    webFrame = App.frame
    self.view = UIView.alloc.initWithFrame(webFrame)
    self.view.backgroundColor = background
    self.view.autoresizesSubviews = true
    webFrame.origin.y = 0.5

    [background, webFrame]
  end
end