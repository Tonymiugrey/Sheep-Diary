//
//  SheepApp.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/29.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds
import UserMessagingPlatform
import AdSupport

@main
struct SheepApp: App {
    let persistenceController = PersistenceController.shared
    
    private func initGoogleMobileAds() {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "a52111efdf442822bcd6d4847f5259e9" ]
        GADMobileAds.sharedInstance()
            .start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "a52111efdf442822bcd6d4847f5259e9" ]
    }
    
    private func requestIDFA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                print("ad id:")
                print(ASIdentifierManager.shared().advertisingIdentifier)
                print("IDFA STATUS: \(status)")
                switch status {
                case .denied, .restricted, .authorized:break
                case .notDetermined:
                    #if targetEnvironment(simulator)
                    #else
                    showConsentInformation()
                    #endif
                @unknown default: break
                }
            }
      }
    }
    
    private func showConsentInformation() {
        let parameters = UMPRequestParameters()
        
        // false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                    // Handle the error.
                } else {
                    // The consent information state was updated.
                    // You are now ready to check if a form is
                    // available.
                    loadForm()
                }
            })
        
    }
    
    func loadForm() {
        UMPConsentForm.load(
            completionHandler: { form, loadError in
                if loadError != nil {
                    // Handle the error
                } else {
                    // Present the form
                    if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
                        form?.present(from: UIApplication.shared.windows.first!.rootViewController! as UIViewController, completionHandler: { dimissError in
                            if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                // App can start requesting ads.
                                initGoogleMobileAds()
                            }
                        })
                    }
                }
            })
    }
    
    init() {
        requestIDFA()
        Thread.sleep(forTimeInterval: 1)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(TabBarColor())
        }
    }
}
