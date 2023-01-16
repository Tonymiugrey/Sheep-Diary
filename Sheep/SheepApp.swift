//
//  SheepApp.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/29.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        GADMobileAds.sharedInstance().start()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        //GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "ef8938db1c2793d05b9370a4eb14a93c" ]
        
        Thread.sleep(forTimeInterval: 1) // pause 2 sec before main storybord shows
        
        return true
    }
}


@main
struct SheepApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tint(Color("AccentColor"))
        }
    }
}
