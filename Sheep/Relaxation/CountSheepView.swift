//
//  CountSheepView.swift
//  Sheep
//
//  Created by miuGrey on 2023/3/2.
//

import SwiftUI
import StoreKit

struct CountSheepView: View {
    var title:LocalizedStringKey = "数羊"
    var subTitle1:LocalizedStringKey = "难受到睡不着吗"
    var subTitle2:LocalizedStringKey = "数一数羊看看会不会好一些"
    @State var total = 0
    @State var once = 1
    @State var isTapped = false
    @State var XMovingOffset:CGFloat = 0
    @State var YMovingOffset:CGFloat = 0
    @State var sheepOpacity:CGFloat = 1
    @State var sheepAngle:CGFloat = 0
    @State var isMoving = false
    @State var isShow = true
    @State var sheepScale = 1.3
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    @State var showSharingView = false
    let generator = UINotificationFeedbackGenerator()
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var wordDuration:CFloat = 0.0
    
    var wordList = ["放空大脑…", "慢慢点击有助于放松哦", "实在睡不着的话，闭目养神也可以的", "别担心", "可以去小羊日记里写一写感受", "不能慌乱呀", "试着做个深呼吸", "保持平和的心情"]
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        //let luckyNum = input.truncatingRemainder(dividingBy: 7)
        if input == 6 && reviewHasShown == false{
            print("Please Rate")
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .fontWeight(.heavy)
                                .font(.system(size: 46))
                                .padding(.bottom, 0.5)
                            
                            Spacer()
                            
                            HStack {
                                Button {
                                    self.showSharingView = true
                                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                                    impactLight.impactOccurred()
                                } label: {
                                    Image(systemName: "square.and.arrow.up.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40)
                                }
                                .fullScreenCover(isPresented: $showSharingView)
                                {
                                    ShareContentView(viewToShot: CountSheepShare(times: total)
                                        .environmentObject(TodoListViewModel(testData: false)), title: "数羊 - 分享自 小羊日记App")
                                    .foregroundColor(Color("TextColor"))
                                }
                            }
                            .padding(.trailing, deviceWidth/10)
                        }
                        Text(subTitle1)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.bottom, -5)
                        Text(subTitle2)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .foregroundColor((Color("CountSheepColor1")))
                .frame(width: deviceWidth, alignment: .leading)
                .padding(.leading, deviceWidth/10)
                .padding(.top, -deviceHeight/8)
                
                VStack {
                    Image("Sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(width: deviceWidth/2.2)
                        .scaleEffect(sheepScale)
                        .offset(x:XMovingOffset, y:YMovingOffset)
                        .opacity(sheepOpacity)
                        .rotationEffect(.degrees(sheepAngle))
                        .onTapGesture {
                            if isMoving == false {
                                self.generator.notificationOccurred(.error)
                                withAnimation(Animation.spring(response: 1.4, dampingFraction: 0.4, blendDuration: 0.7)) {
                                    sheepScale = 0.6
                                    sheepAngle = -20
                                    XMovingOffset = -deviceWidth
                                    YMovingOffset = -240
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        YMovingOffset = 120
                                        sheepOpacity = 0
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.generator.notificationOccurred(.error)
                                    XMovingOffset = deviceWidth
                                    YMovingOffset = -300
                                    sheepAngle = 40
                                    withAnimation(Animation.spring(response: 1.2, dampingFraction: 0.75, blendDuration: 0.2)) {
                                        sheepScale = 1.3
                                        YMovingOffset = 0
                                        sheepOpacity = 1
                                        XMovingOffset = 0
                                        sheepAngle = 0
                                    }
                                }
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                                total += once

                                withAnimation() {
                                    isMoving.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                        self.isMoving.toggle()
                                    }
                            }
                            }
                        }
                }
                .padding(.top, deviceHeight/7)
                .padding(.bottom,deviceHeight/7)
                
                VStack(spacing: 5){
                    Text(LocalizedStringKey(wordList[Int(wordDuration)]))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("\(total)只羊")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("CountSheepColor2"))
                .animation(.easeInOut(duration: 0.4))
                .padding(.bottom, -deviceHeight/4)
                .onReceive(timer, perform: { _ in
                    if wordDuration >= 6.9 {
                        wordDuration = 0
                    } else {
                        wordDuration += 0.015
                    }
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.linearGradient(colors: [Color("CountSheepBG1"),Color("CountSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            isShow = true
        }
        .onDisappear() {
            isShow = false
        }
        .tint(Color("SheepColor"))
    }
}

struct CountSheepView_Previews: PreviewProvider {
    static var previews: some View {
        CountSheepView()
    }
}
