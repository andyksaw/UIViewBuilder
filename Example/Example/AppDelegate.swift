//
//  AppDelegate.swift
//  Example
//
//  Created by tarunon on 2020/01/05.
//  Copyright © 2020 tarunon. All rights reserved.
//

import UIKit
import UIViewBuilder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var emoji = [String]()

    lazy var vc = HostingController {
        List {
            ForEach(data: self.emoji) { text in
                VStack {
                    Spacer()
                    Label(text: text)
                    Spacer()
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
        } else {

            for codePoint in 0x1F600...0x1F64F {
                guard let scalarValue = Unicode.Scalar(codePoint) else {
                    continue
                }
                emoji.append(String(scalarValue))
            }
            
            let window = UIWindow()
            window.rootViewController = vc
            window.makeKeyAndVisible()
            self.window = window

            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shuffle), userInfo: nil, repeats: true)
        }
        return true
    }

    @objc func shuffle() {
        vc.component.body.data = emoji.shuffled()
    }


    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

