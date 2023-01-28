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

func requestReviewManually() {
    // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
    // You can find the App Store ID in your app's product URL
    guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/idXXXXXXXXXX?action=write-review")
    else { fatalError("Expected a valid URL") }
    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
}

struct IAPButton: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false

    let product: Product
    let purchasingEnabled: Bool

    var emoji: String {
        store.emoji(for: product.id)
    }

    init(product: Product, purchasingEnabled: Bool = true) {
        self.product = product
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            if purchasingEnabled {
                buyButton
                    .disabled(isPurchased)
            } else {
                productDetail
            }
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("OK")))
        })
    }

    @ViewBuilder
    var productDetail: some View {
        if product.type == .autoRenewable {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                Text(product.description)
            }
        } else {
            Text(product.description)
                .frame(alignment: .leading)
        }
    }

    var buyButton: some View {
        Button(action: {
            Task {
                await buy()
            }
        }) {
            if isPurchased {
                Text("感谢支持！广告已移除！")
                    .bold()
            } else {
                Text("\(product.displayName) \(product.displayPrice)")
                    .bold()
            }
        }
        .onAppear {
            Task {
                isPurchased = (try? await store.isPurchased(product)) ?? false
            }
        }
    }

    func buy() async {
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}


struct AboutView: View {
    @EnvironmentObject var store: Store
    
    
    var body: some View {
        NavigationView {
            List {
                Section("免责申明") {
                    Text("此App带有分享功能，本意为用于互相帮助。由于分享内容较为严肃，请勿传播虚假信息；用户通过此App传播的信息仅代表用户立场，与“小羊日记”及其开发者无关。")
                }
                
                Section("安全与注意事项") {
                    Text("症状与应对措施因人而异，由该应用分享的内容仅做为参考。请结合自身情况，谨慎判断或遵循医嘱。")
                }
                
                Section("广告与隐私") {
                    Text("该应用包含 Google AdMob 广告框架，会收集部分信息用于提供个性化广告服务。这些信息由 Google 收集，我不会收集或获得任何关于用户的个人信息。")
                    Button {
                        UIApplication.shared.open(URL(string:"https://sheep-diary.miuGrey.com.cn/#privacy")!)
                    } label: {
                        Text("隐私政策")
                    }
                }
                
                Section("支持作者") {
                    Text("我在应用中加入了广告，以支撑我的后续开发。如果您觉得这个App还不错的话，可以点击下方的内购按钮去除广告。感谢支持！")
                    if store.Prod.count != 0 {
                        ForEach(store.Prod) { prod in
                            IAPButton(product: prod)
                        }
                    } else if store.Prod.count == 0 && store.purchasedProd.count == 0 {
                        Button {

                        } label: {
                            Text("应用内购买项目暂时不可用") // 本地化
                        }
                        .disabled(true)
                    } else {
                        Button {

                        } label: {
                            Text("感谢支持！广告已移除！") // 本地化
                                .bold()
                        }
                        .disabled(true)

                    }

                    if store.Prod.count != 0 && store.purchasedProd.count == 0 {
                        Button("恢复已购项目", action: {
                            Task {
                                //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                //Call this function only in response to an explicit user action, such as tapping a button.
                                try? await AppStore.sync()
                            }
                        })
                    }
                }
                
                Section {
                    Button {
                        requestReviewManually()
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
    //@State static var purchased = false
    static var previews: some View {
        AboutView()
            .environmentObject(Store())
    }
}
