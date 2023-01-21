//
//  ContentView.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/29.
//

import SwiftUI
import CoreData
import StoreKit

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}


extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
    

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct Tool {
    static func showTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hiddenTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                view.isHidden = true
            }
        })
    }
}


struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                Tool.showTabBar()
            }
        }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
    }
}

extension View {
    
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}

struct ContentView: View {
    @State var color = Color("NoSheepColor")
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        //let luckyNum = input.truncatingRemainder(dividingBy: 7)
        if input == 43 && reviewHasShown == false {
            print("Please Rate")
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    let hour = Calendar.current.component(.hour, from: Date())

    var body: some View {
        TabView {
            NoSheepView()
                .tabItem {
                    //修改未选择的项的颜色
                    Label("别羊", systemImage: "shield.lefthalf.filled")
                }
                .onAppear() {
                    color = Color("NoSheepColor")
                }
                .tag(1)
            FakeSheepView()
                .tabItem { Label("幻羊", systemImage: "ellipsis.bubble.fill").tint(Color("FakeSheepColor1")) }
                .onAppear() {
                    color = Color("FakeSheepColor")
                }
                .tag(2)
            SheepView()
                .showTabBar()
                .onAppear() {
                    color = Color("SheepColor")
                    RandomRate(input: CGFloat.random(in: 0...65))
                }
                .tabItem { Label("羊了", systemImage: "facemask.fill") }
                .tag(3)
        //    if hour >= 22 || hour <= 6 {
               // SleepSheepView()
                  //  .tabItem { Label("数羊", systemImage: "tray.and.arrow.down.fill") }
                   // .tag(4)
        //    }
            AboutView()
                .tint(Color("SheepColor"))
                .tabItem {
                    Label("关于", systemImage: "info.circle.fill")
                }
                .onAppear() {
                    color = Color("SheepColor")
                }
                .tag(5)
        
        }
        .tint(color)
        //.animation(.easeInOut, value: color)
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ContentView().previewDevice("iPad Air (5th generation)").preferredColorScheme(.light).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
