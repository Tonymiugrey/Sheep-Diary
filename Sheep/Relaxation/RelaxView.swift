//
//  RelaxView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/26.
//

import SwiftUI

struct RelaxView: View {
    @EnvironmentObject var tabBarColor: TabBarColor
    @EnvironmentObject var store: Store
    @State var pickerValue = 0
    @State var isShow = true
    @State var showAd = false
    @State var switchCount = 0.0
    @State var wordsJumpingOffset:CGFloat = -32
    @State var wordsOpacity:CGFloat = 0
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            SheepView()
                .opacity(pickerValue == 2 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value == 2 {
                        tabBarColor.color = Color("SheepColor")
                        tabBarColor.buttonColor = Color("SheepColor2")
                    }
                })
                .animation(.easeInOut, value: pickerValue)
            
            FakeSheepView()
                .environmentObject(store)
                .opacity(pickerValue == 1 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value == 1 {
                        tabBarColor.color = Color("FakeSheepColor")
                        tabBarColor.buttonColor = Color("FakeSheepColor2")
                    }
                })
                .animation(.easeInOut, value: pickerValue)
            
            NoSheepView(isShowBinding: $isShow)
                .environmentObject(store)
                .opacity(pickerValue == 0 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value != 0 {
                        print(isShow)
                        isShow = false
                    } else {
                        isShow = true
                        tabBarColor.color = Color("NoSheepColor")
                        tabBarColor.buttonColor = Color("NoSheepColor2")
                    }
                })
                .animation(.easeInOut, value: pickerValue)
            
            CountSheepView()
                .opacity(pickerValue == 3 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value == 3 {
                        tabBarColor.color = Color("CountSheepColor")
                        tabBarColor.buttonColor = Color("CountSheepColor2")
                    }
                })
                .animation(.easeInOut, value: pickerValue)

            HStack {
                HStack {
                    Text("点击这里切换场景 →")
                        .fontWeight(.medium)
                }
                .offset(x:wordsJumpingOffset, y:0)
                .opacity(wordsOpacity)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        wordsOpacity = 1
                        wordsJumpingOffset = -5
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            wordsJumpingOffset = -32
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                wordsJumpingOffset = -5
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    wordsJumpingOffset = -32
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        wordsJumpingOffset = -5
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            wordsOpacity = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .animation(.spring(response:0.6, dampingFraction: 0.4, blendDuration: 1), value: wordsJumpingOffset)
                .animation(.easeInOut(duration: 0.5), value: wordsOpacity)
                Menu() {
                    Button() {
                        pickerValue = 0
                    } label: {
                        HStack {
                            Text("别羊")
                            if pickerValue == 0{
                                Image(systemName: "checkmark")
                            }
                        }
                        
                    }
                    
                    Button() {
                        pickerValue = 1
                    } label: {
                        HStack {
                            Text("幻羊")
                            if pickerValue == 1{
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button() {
                        pickerValue = 2
                    } label: {
                        HStack {
                            Text("羊了")
                            if pickerValue == 2{
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button() {
                        pickerValue = 3
                    } label: {
                        HStack {
                            Text("数羊")
                            if pickerValue == 3{
                                Image(systemName: "checkmark")
                            }
                        }
                        
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
                .onTapGesture {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }
                .onChange(of: pickerValue) { _ in
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                    switchCount += 1
                    if switchCount.truncatingRemainder(dividingBy: 4) == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            if store.purchasedProd.count == 0 {
                                showAd.toggle()
                            }
                        }
                    }
                }
            }
            .padding(.top, deviceHeight/1.35)
            .padding(.leading, deviceWidth/2.8)
            .foregroundColor(tabBarColor.buttonColor)
            
            
        }
        .presentInterstitialAd(isPresented: $showAd, adUnitId: "ca-app-pub-6106285619802028/6409939605")
        .onAppear() {
            if pickerValue == 0 {
                isShow = true
                tabBarColor.color = Color("NoSheepColor")
                tabBarColor.buttonColor = Color("NoSheepColor2")
            } else if pickerValue == 1 {
                tabBarColor.color = Color("FakeSheepColor")
                tabBarColor.buttonColor = Color("FakeSheepColor2")
            } else if pickerValue == 2 {
                tabBarColor.color = Color("SheepColor")
                tabBarColor.buttonColor = Color("FakeSheepColor2")
            } else if pickerValue == 3 {
                tabBarColor.color = Color("CountSheepColor")
                tabBarColor.buttonColor = Color("CountSheepColor2")
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
            .environmentObject(TabBarColor())
            .environmentObject(Store())
    }
}
