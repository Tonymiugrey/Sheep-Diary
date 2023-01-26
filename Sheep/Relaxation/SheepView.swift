//
//  SheepView.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/30.
//

import SwiftUI
import StoreKit

struct SheepView: View {
    var title:LocalizedStringKey = "羊了"
    var subTitle1:LocalizedStringKey = "那就撸撸小羊放松一下吧"
    var subTitle2:LocalizedStringKey = "可以记录一下身体状况和应对措施哦"
    @State var total = 0
    @State var once = 1
    @State var isTapped = false
    @State var isMoving = false
    @State var isShow = true
    @State var sheepScale = 1.3
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    @State var showSharingView = false
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var wordDuration:CFloat = 0.0
    var wordList = ["冷静呀", "慢慢点击有助于放松哦", "可以去小羊日记里写一写感受", "如果累了就休息一下吧", "别怕，会没事的", "你可以的", "不能慌乱呀", "试着做个深呼吸", "保持平和的心情"] // TODO: 本地化
    
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
                            
                            Button {
                                self.showSharingView = true
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                            } label: {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .padding(.trailing, deviceWidth/10)
                            }
                            .fullScreenCover(isPresented: $showSharingView)
                            {
                                ShareContentView(viewToShot: SheepShare(times: total)
                                    .environmentObject(TodoListViewModel(testData: false)), title: "羊了 - 分享自 小羊日记App")
                                .foregroundColor(Color("TextColor"))
                            }
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
                .foregroundColor((Color("SheepColor1")))
                .frame(width: deviceWidth, alignment: .leading)
                .padding(.leading, deviceWidth/10)
                .padding(.top, -deviceHeight/8)
                
                VStack {
                    Image("Sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(width: deviceWidth/2.2)
                        .scaleEffect(isTapped ? sheepScale - 0.2 : sheepScale)
                        .animation(.easeInOut(duration: 0.2), value: isTapped)
                        .onTapGesture {
                            if isMoving == false {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                                total += once
                                withAnimation {
                                    isTapped.toggle()
                                    isMoving.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.isTapped.toggle()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
                    Text("撸羊\(total)次")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("SheepColor2"))
                .animation(.easeInOut(duration: 0.4))
                .padding(.bottom, -deviceHeight/4)
                .onReceive(timer, perform: { _ in
                    if wordDuration >= 8.9 {
                        wordDuration = 0
                    } else {
                        wordDuration += 0.015
                    }
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.linearGradient(colors: [Color("SheepBG1"),Color("SheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
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

struct SheepView_Previews: PreviewProvider {
    static var previews: some View {
        SheepView()
    }
}
