import UIKit
import FirebaseCore
import GoogleSignIn
import os

class AppDelegate: NSObject, UIApplicationDelegate {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AppDelegate")
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        logger.info("Configuring Firebase")
        FirebaseApp.configure()
        
        // Configure GIDSignIn
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            logger.error("Failed to get Google client ID from FirebaseApp")
            return false
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        logger.info("Handling URL: \(url.absoluteString)")
        return GIDSignIn.sharedInstance.handle(url)
    }
}
