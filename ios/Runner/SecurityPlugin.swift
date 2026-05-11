import Foundation
import Flutter
import UIKit

class SecurityPlugin: NSObject, FlutterPlugin {
    static let channel = "safeguard_link/security"
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channel, binaryMessenger: registrar.messenger())
        let instance = SecurityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enableSecureMode":
            enableSecureMode()
            result(true)
        case "checkScreenMirroring":
            let isMirroring = isScreenMirroring()
            result(isMirroring)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func enableSecureMode() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.isSecure = true
            }
        }
    }
    
    private func isScreenMirroring() -> Bool {
        // Check if screen recording or mirroring is active
        return UIScreen.main.isCaptured || UIScreen.main.mirroredScreenMode != .none
    }
}
