import Flutter
import UIKit

public class WindowManagerPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "window_manager", binaryMessenger: registrar.messenger())
        let instance = WindowManagerPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        
        let scanResultEvents = FlutterEventChannel(name: "window_manager/events", binaryMessenger: registrar.messenger())
        
        scanResultEvents.setStreamHandler(ScreenCaptureEvents())
    }
    
    private var textField = UITextField();
    private var screenshotBlock = false
    private var firstInit = false
    private var isPrivacyEnabled = false
    
    private var screenshotObserve: NSObjectProtocol? = nil
    private var screenRecordObserve: NSObjectProtocol? = nil
    private var becomeActiveNotification: NSObjectProtocol? = nil
    private var tempObserver: NSObjectProtocol? = nil
    private var resignActiveNotification: NSObjectProtocol? = nil
    
    public  static var screenCaptureEventSink: FlutterEventSink? = nil;
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "blockScreenShot":
            screenshotBlock = true;
            setupObserver()
            if firstInit {
                textField.isSecureTextEntry = true;
            } else{
                UIApplication.shared.keyWindow?.blockScreenshot(field:  textField);
                firstInit=true
            }
            result("Block called ios")
        case "unblockScreenShot":
            removeAllObserver()
            screenshotBlock = false;
            UIApplication.shared.keyWindow?.unblockScreenshot(field: textField);
            result("Unblock called ios")
        case "isBlockScreenShot":
            result(screenshotBlock)
        case "enablePrivacyScreen":
            if(isPrivacyEnabled == false){
                isPrivacyEnabled = true;
                setupPrivacyScreenObserver()
            }
            
            result("Enable privacy screen called ios: \(isPrivacyEnabled)")
        case "disablePrivacyScreen":
            isPrivacyEnabled = false;
            removePrivacyScreenObserver()
            result("Disable privacy screen called ios")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func setupObserver(){
        print("setupObserver")
        
        screenshotObserver{
            print("Screenshot making")
            WindowManagerPlugin.screenCaptureEventSink?(true);
            
        }
        
        if #available(iOS 11.0, *) {
            screenRecordObserver { isCaptured in
                print("Screenshot making video  \(isCaptured)")
                WindowManagerPlugin.screenCaptureEventSink?(isCaptured);
            }
        }
    }
    
    
    public func screenshotObserver(using onScreenshot: @escaping () -> Void) {
        screenshotObserve = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            onScreenshot()
        }
    }
    
    // How to used:
    //
    // if #available(iOS 11.0, *) {
    //     screenProtectorKit.screenRecordObserver { isCaptured in
    //         // Callback on Screen Record
    //     }
    // }
    @available(iOS 11.0, *)
    public func screenRecordObserver(using onScreenRecord: @escaping (Bool) -> Void) {
        screenRecordObserve =
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            let isCaptured = UIScreen.main.isCaptured
            onScreenRecord(isCaptured)
        }
    }
    
    
    
    public func removeAllObserver() {
        print("removeAllObserver")
        removeScreenRecordObserver()
        removeScreenshotObserver()
    }
    
    
    
    
    public func removeScreenRecordObserver() {
        if screenRecordObserve != nil {
            self.removeObserver(observer: screenRecordObserve)
            self.screenRecordObserve = nil
        }
    }
    
    
    public func removeScreenshotObserver() {
        if screenshotObserve != nil {
            self.removeObserver(observer: screenshotObserve)
            self.screenshotObserve = nil
        }
    }
    
    public func removeObserver(observer: NSObjectProtocol?) {
        guard let obs = observer else {return}
        NotificationCenter.default.removeObserver(obs)
    }
    
    
    public func setupPrivacyScreenObserver(){
        print("setupPrivacyScreenObserver")
        
        if let window = UIApplication.shared.windows.first {
          let v = window.rootViewController?.view
          v?.backgroundColor = .clear

          let blurEffect = UIBlurEffect(style: .light)
          let blurEffectView = UIVisualEffectView(effect: blurEffect)

          // Always fill the view
          blurEffectView.frame = v?.bounds ?? CGRect.zero
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          blurEffectView.tag = 55

          v?.addSubview(blurEffectView)
        }
    }

    public func removePrivacyScreenObserver() {
        print("removePrivacyScreenObserver")
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.view?.viewWithTag(55)?.removeFromSuperview()
        }
    }
    
}

extension UIWindow {
    
    func blockScreenshot(field: UITextField) {
        DispatchQueue.main.async {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.self.width, height: field.frame.self.height))
            field.isSecureTextEntry = true
            self.addSubview(field)
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.last!.addSublayer(self.layer)
            field.leftView = view
            field.leftViewMode = .always
        }
    }
    
    func unblockScreenshot(field: UITextField) {
        field.isSecureTextEntry = false
        print("ios unblock");
    }
}





class ScreenCaptureEvents: NSObject, FlutterStreamHandler{
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        WindowManagerPlugin.screenCaptureEventSink = events
        return nil
    }
    
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        WindowManagerPlugin.screenCaptureEventSink = nil;
        return nil
    }
}
