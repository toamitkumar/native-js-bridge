class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @viewController = MainViewController.alloc.init

    @window.rootViewController = @viewController
    @window.makeKeyAndVisible

    true
  end
end
