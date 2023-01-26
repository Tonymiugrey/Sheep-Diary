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


class TabBarColor: ObservableObject {
    @Published var color: Color = Color("SheepColor")
}

struct ContentView: View {
    @EnvironmentObject var tabBarColor: TabBarColor
    @State var reviewHasShown = false
    
    @StateObject var store: Store = Store()
    
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
            NavigationView {
                TodoListView()
                    .showTabBar()
                    .environmentObject(TodoListViewModel())
                    .environmentObject(Store())
            }
                .tabItem {
                    //修改未选择的项的颜色
                    Label("小羊日记", systemImage: "note.text")
                }
                .onAppear() {
                    tabBarColor.color = Color("SheepColor")
                }
                .tag(0)
            RelaxView()
                .environmentObject(tabBarColor)
                .tint(Color("SheepColor"))
                .tabItem {
                    Label("放松", systemImage: "face.smiling") // TODO: 本地化
                }
                .tag(1)
            AboutView()
                .environmentObject(store)
                .tint(Color("SheepColor"))
                .tabItem {
                    Label("关于", systemImage: "info.circle")
                }
                .onAppear() {
                    tabBarColor.color = Color("SheepColor")
                }
                .tag(2)
        
        }
        .tint(tabBarColor.color)
        //.animation(.easeInOut, value: color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TabBarColor())
        ContentView().previewDevice("iPad Air (5th generation)")
            .preferredColorScheme(.light)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)            .environmentObject(TabBarColor())
    }
}
