//
//  AboutView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/19.
//

import SwiftUI
import StoreKit

extension Bundle {
    
    public var appVersionShort: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            return "??"
        }
    }
    public var appVersionLong: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            return "??"
        }
    }
    public var appName: String {
        if let result = infoDictionary?["CFBundleDisplayName"] as? String {
            return result
        } else {
            return "??"
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            List {
                Section("免责申明与注意事项") {
                    Text("此App带有分享功能，本意为用于互相帮助。由于分享内容较为严肃，请勿传播虚假信息。用户通过此App传播的信息仅代表用户立场，与“别羊”及其开发者无关。")
                }
                
                Section("广告与隐私") {
                    Text("该应用包含 Google AdMob 广告框架，会收集部分信息用于提供个性化广告服务。这些信息由 Google 收集，我不会收集或获得任何关于用户的个人信息。")
                    Button {
                        UIApplication.shared.open(URL(string:"https://doc-hosting.flycricket.io/bie-yang-privacy-policy/c5846993-4a22-4a17-9f99-ab642f3c170b/privacy")!)
                    } label: {
                        Text("隐私政策")
                    }
                }
                Section("支持作者") {
//                    Text("我在应用中加入了广告，以支撑我的后续开发。如果您觉得这个App还不错的话，可以点击下方的内购按钮去除广告。感谢支持！")
//                    Button {
//                        
//                    } label: {
//                        Text("￥6  去除广告")
//                    }
                    Button {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    } label: {
                        Label("给个好评吧！", systemImage: "star.bubble")
                    }
                }
                
                Section {
                    Text("\(Bundle.main.appName) \(Bundle.main.appVersionShort) Build \(Bundle.main.appVersionLong)")
                    Text("© miuGrey 2023")
                }
                
            }
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
