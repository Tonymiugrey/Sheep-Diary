//
//  NoSheepView.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/30.
//

import SwiftUI
import StoreKit

struct NoSheepView: View {
    var title:LocalizedStringKey = "别羊"
    var subTitle1:LocalizedStringKey = "但是小羊还是很可爱的！"
    var subTitle2:LocalizedStringKey = "这里的“羊”仅仅指“阳”"
    @State var total = 0
    @State var once = 1
    @State var score = 0
    @State var totalScore = 0
    @State var isTapped = false
    @State var sheepScale = 0.5
    @State var isReached = false
    @Binding var isShowBinding:Bool
    @State var isShow = true
    @State var noticeColor = Color.green
    @State var noticeTextColor = Color("GreenTextColor")
    @State var sheepStatus:LocalizedStringKey = "慢慢戳羊，保持距离！"  // TODO: 本地化
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    @State var showSharingView = false
    @State var reactTime = 0.3
    @State var stage1MoveBack = 0.02
    @State var stage2MoveBack = 0.04
    @State var stage3MoveBack = 0.08
    @State var speed = 0.04
    
    @State var reviewHasShown = false
    func RandomRate() {
        if total == 150 && reviewHasShown == false {
            print("Please Rate")
            reviewHasShown = true
            isShow = false
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var wordDuration:CFloat = 0.0
    
    var wordList = ["冷静呀","记得做好防护", "慢慢点击有助于放松哦", "别怕，会没事的", "不能慌乱呀", "试着做个深呼吸", "保持平和的心情"]

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
                            
                            HStack(spacing: 22) {
                                Button {
                                    isShow = false
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
                                    ShareContentView(viewToShot: NoSheepShare(times: total, totalScore: totalScore)
                                        .environmentObject(TodoListViewModel(testData: false)), title: "别羊🙏🏻 - 分享自 小羊日记App")
                                    .foregroundColor(Color("TextColor"))
                                }
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
                .foregroundColor((Color("NoSheepColor1")))
                .frame(width: deviceWidth, alignment: .leading)
                .padding(.leading, deviceWidth/10)
                .padding(.top, -deviceHeight/4.7)
                
                VStack {
                    Image("Sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(width: deviceWidth/2)
                        .scaleEffect(isTapped ? sheepScale - 0.02 : sheepScale)
                        .opacity(isReached ? 0 : 1)
                        .animation(.easeInOut(duration: 1.8), value: isReached)
                        .onReceive(timer, perform: { _ in
                            if wordDuration >= 6.9 {
                                wordDuration = 0
                            } else {
                                wordDuration += 0.015
                            }
                            if isShowBinding && isShow {
                                isShow = true
                                if sheepScale <= 2{
                                    if isTapped {
                                        if sheepScale >= 0.25 && sheepScale < 1.05 {
                                            sheepScale -= stage1MoveBack
                                        }
                                        if sheepScale >= 1.05 && sheepScale < 1.6 {
                                            sheepScale -= stage2MoveBack
                                        }
                                        if sheepScale >= 1.6 && sheepScale < 2 {
                                            sheepScale -= stage3MoveBack
                                        }
                                    } else {
                                        isReached = false
                                        sheepScale += speed
                                        if sheepScale >= 0.25 && sheepScale < 1.25 {
                                            noticeColor = Color.green
                                            sheepStatus = "慢慢戳羊，保持距离！" // TODO: 本地化
                                            noticeTextColor = Color("GreenTextColor")
                                        }
                                        if sheepScale >= 1.25 && sheepScale < 1.7 {
                                            noticeColor = Color.yellow
                                            sheepStatus = "不着急，慢慢戳！" // TODO: 本地化
                                            noticeTextColor = Color("YellowTextColor")
                                        }
                                        if sheepScale >= 1.7 && sheepScale < 2 {
                                            noticeColor = Color.red
                                            sheepStatus = "别慌！沉住气！" // TODO: 本地化
                                            noticeTextColor = Color("RedTextColor")
                                        }
                                    }
                                } else if sheepScale >= 2 {
                                    noticeColor = Color.gray
                                    noticeTextColor = Color(.black)
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                                    impactHeavy.impactOccurred()
                                    sheepStatus = "戳不动？静下心慢慢戳吧" // TODO: 本地化
                                    isReached = true
                                    sheepScale += 1
                                    if totalScore > 0 {
                                        score = -1
                                        totalScore += score
                                    }
                                    if sheepScale > 42{
                                        sheepScale = 0.2
                                    }
                                    
                                }
                            } else {
                                isShow = false
                                noticeColor = Color("SheepColor")
                                sheepStatus = "点击这里继续"
                                noticeTextColor = Color("YellowTextColor")
                            }
                        })
                        .animation(.easeOut, value: sheepScale)
                        .onTapGesture {
                            if isShow {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                                
                                total += once
                                if sheepScale >= 0.20 && sheepScale < 1.25 {
                                    score = 10
                                    totalScore += score
                                }
                                if sheepScale >= 1.25 && sheepScale < 1.7 {
                                    score = 5
                                    totalScore += score
                                }
                                if sheepScale >= 1.7 && sheepScale < 2 {
                                    score = 1
                                    totalScore += score
                                }
                                withAnimation {
                                    isTapped.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + reactTime) {
                                        self.isTapped.toggle()
                                    }
                                }
                                RandomRate()
                            }
                        }
                }
                .padding(.top,deviceHeight/18)
                .padding(.bottom,deviceHeight/17)
                
                VStack(spacing: 10) {
                    ZStack {
                        Text(LocalizedStringKey(wordList[Int(wordDuration)]))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("NoSheepColor2"))
                            .opacity(0.7)
                    }
                    .animation(.easeInOut)
                    
                    Button {
                        isShow = true
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: deviceWidth/1.5, height: 60)
                                .foregroundColor(noticeColor)
                                .opacity(0.9)
                                .foregroundStyle(.thickMaterial)
                                .animation(.easeInOut(duration: 0.2), value: noticeColor)
                            Text(sheepStatus)
                                .font(.title3)
                                .foregroundColor(noticeTextColor)
                                .fontWeight(.medium)
                                .animation(.easeInOut(duration: 0.1), value: sheepStatus)
                        }
                    }
                    .disabled(isShow)
                    
                    Text("戳羊\(total)次，镇定值\(totalScore)") // TODO: 本地化
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("NoSheepColor2"))
                        .animation(.easeInOut(duration: 0.4), value: total)
                        .opacity(0.7)
                        .foregroundStyle(.thickMaterial)
                        
                }
                .padding(.bottom,-deviceHeight/3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.linearGradient(colors: [Color("NoSheepBG1"),Color("NoSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NoSheepView_Previews: PreviewProvider {
    @State static var isShow = true
    static var previews: some View {
        NoSheepView(isShowBinding: $isShow)
            .previewDevice("iPhone 14 Pro Max")
    }
}
