//
//  AppDelegate.swift
//  iOSWidgetExplorer
//
//  Created by 200OK-IOS4 on 12/08/24.
//

import UIKit
import BackgroundTasks
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.=
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let host = url.host {
            if host == "PostSummary" {
                // Navigate to the specific view in your app
                let postTitle = url.lastPathComponent.removingPercentEncoding
                navigateToPostDetailView(withTitle: postTitle ?? "")
            }
        }
        return true
    }
    
    func navigateToPostDetailView(withTitle title: String?) {
         // Ensure the window is set up
         guard let window = window else { return }

         // Get the root view controller
         let rootViewController = window.rootViewController

        let sb = UIStoryboard(name: "Main", bundle: .main)
        
        // Ensure the identifier is correctly set in the storyboard
        if let viewController = sb.instantiateViewController(withIdentifier: "PostSummary") as? PostSummary {
            viewController.postTitle = title // Pass data to the view controller
            rootViewController?.present(viewController, animated: true, completion: nil)
        } else {
            print("Failed to instantiate view controller with identifier 'PostDetail'")
        }
     }

}
