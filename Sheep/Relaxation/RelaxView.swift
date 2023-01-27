//
//  RelaxView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/26.
//

import SwiftUI

struct RelaxView: View {
    @EnvironmentObject var tabBarColor: TabBarColor
    @State var pickerValue = 0
    @State var isShow = true
    var deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            SheepView()
                .opacity(pickerValue == 2 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value == 2 {
                        tabBarColor.color = Color("SheepColor")
                    }
                })
            
            FakeSheepView()
                .opacity(pickerValue == 1 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value == 1 {
                        tabBarColor.color = Color("FakeSheepColor")
                    }
                })
            
            NoSheepView(isShowBinding: $isShow)
                .opacity(pickerValue == 0 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value != 0 {
                        print(isShow)
                        isShow = false
                    } else {
                        isShow = true
                        tabBarColor.color = Color("NoSheepColor")
                    }
                })

            
            Picker(selection: $pickerValue, label: Text("选择场景")) {
                Text("别羊")
                    .tag(0)
                Text("幻羊")
                    .tag(1)
                Text("羊了")
                    .tag(2)

            }
            .onChange(of: pickerValue) { _ in
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
            }
            .pickerStyle(.segmented)
            .background(.thinMaterial)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top, deviceHeight/1.23)
        }
        .onAppear() {
            if pickerValue == 0 {
                isShow = true
                tabBarColor.color = Color("NoSheepColor")
            } else if pickerValue == 1 {
                tabBarColor.color = Color("FakeSheepColor")
            } else if pickerValue == 2 {
                tabBarColor.color = Color("SheepColor")
            }
        }
        .onDisappear() {
            isShow = false
        }
    }
}

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        RelaxView()
            .previewDevice("iPhone SE (3rd generation)")
            .environmentObject(TabBarColor())
    }
}
