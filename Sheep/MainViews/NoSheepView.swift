//
//  NoSheepView.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/30.
//

import SwiftUI
import StoreKit

struct NoSheepView: View {
    private var title:LocalizedStringKey = "别羊"
    private var subTitle1:LocalizedStringKey = "但是小羊还是很可爱的！"
    private var subTitle2:LocalizedStringKey = "这里的“羊”仅仅指“阳”"
    @State private var total = 0
    @State private var once = 1
    @State private var score = 0
    @State private var totalScore = 0
    @State private var isTapped = false
    @State private var sheepScale = 0.5
    @State private var isReached = false
    @State private var isShow = true
    @State private var noticeColor = Color.green
    @State private var noticeTextColor = Color("GreenTextColor")
    @State private var sheepStatus:LocalizedStringKey = "戳羊！别来！"
    private var deviceHeight = UIScreen.main.bounds.height
    private var deviceWidth = UIScreen.main.bounds.width
    @State var showSharingView = false
    @State var difficulty = false
    @State var reactTime = 0.2
    @State var stage1MoveBack = 0.04
    @State var stage2MoveBack = 0.05
    @State var stage3MoveBack = 0.08
    @State var speed = 0.045
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        let luckyNum = input.truncatingRemainder(dividingBy: 7)
        if luckyNum >= 6 && reviewHasShown == false {
            print("Please Rate")
            reviewHasShown = true
            isShow = false
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

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
                                    self.difficulty.toggle()
                                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                                    impactLight.impactOccurred()
                                } label: {
                                    Text(difficulty ? "困难" : "简单")
                                }
                                .tint(Color("NoSheepColor1"))
                                .buttonStyle(.bordered)
                                
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
                                        .environmentObject(TodoListViewModel(testData: false)), title: "别羊🙏🏻 - 分享自 别羊App")
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
                .padding(.top, -deviceHeight/5)
                
                VStack {
                    Image("Sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(width: deviceWidth/2)
                        .scaleEffect(isTapped ? sheepScale - 0.02 : sheepScale)
                        .opacity(isReached ? 0 : 1)
                        .animation(.easeInOut(duration: 1.8), value: isReached)
                        .onReceive(timer, perform: { _ in
                            if isShow{
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
                                            sheepStatus = "戳羊！别来！"
                                            noticeTextColor = Color("GreenTextColor")
                                        }
                                        if sheepScale >= 1.25 && sheepScale < 1.7 {
                                            noticeColor = Color.yellow
                                            sheepStatus = "小心！别让羊来！"
                                            noticeTextColor = Color("YellowTextColor")
                                        }
                                        if sheepScale >= 1.7 && sheepScale < 2 {
                                            noticeColor = Color.red
                                            sheepStatus = "危险！别让羊来！！"
                                            noticeTextColor = Color("RedTextColor")
                                        }
                                    }
                                } else if sheepScale >= 2 {
                                    noticeColor = Color.gray
                                    noticeTextColor = Color(.black)
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                                    impactHeavy.impactOccurred()
                                    sheepStatus = "失败了……"
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
                                noticeColor = Color("SheepColor")
                                sheepStatus = "点击这里继续"
                                noticeTextColor = Color("YellowTextColor")
                            }
                        })
                        .animation(.easeOut, value: sheepScale)
                        .onTapGesture {
                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                            impactLight.impactOccurred()
                            if difficulty {
                                reactTime = 0.3
                                speed = 0.075
                                stage1MoveBack = 0.01
                                stage2MoveBack = 0.027
                                stage3MoveBack = 0.053
                            } else {
                                reactTime = 0.2
                                speed = 0.045
                                stage1MoveBack = 0.047
                                stage2MoveBack = 0.07
                                stage3MoveBack = 0.1
                            }
                            if isShow {
                                total += once
                                if sheepScale >= 0.20 && sheepScale < 1.25 {
                                    score = 3
                                    totalScore += score
                                }
                                if sheepScale >= 1.25 && sheepScale < 1.7 {
                                    score = 10
                                    totalScore += score
                                }
                                if sheepScale >= 1.7 && sheepScale < 2 {
                                    score = 20
                                    totalScore += score
                                }
                                withAnimation {
                                    isTapped.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + reactTime) {
                                        self.isTapped.toggle()
                                    }
                                }
                            }
                        }
                }
                .padding(.top,deviceHeight/18)
                .padding(.bottom,deviceHeight/13)
                
                VStack {
                    ZStack {
                        if sheepScale < 2  {
                            Text("\(score)分")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("NoSheepColor2"))
                                .padding(.bottom, 11.0)
                                .opacity(isTapped ? 0.7 : 0)
                                .animation(.easeInOut(duration: 0.05), value: totalScore)
                        } else if sheepScale >= 2 {
                            Text("戳不动？不妨静下心来慢慢戳吧~")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("NoSheepColor2"))
                                .padding(.bottom, 11.0)
                                .opacity(sheepScale >= 2.0 ? 0.7 : 0)
                                .animation(.easeInOut(duration: 0.4), value: sheepScale)
                        }
                    }
                    .animation(.easeInOut)
                    
                    Button {
                        isShow = true
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: deviceWidth-160, height: 60)
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
                    
                    Text("戳羊\(total)次，总分\(totalScore)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("NoSheepColor2"))
                        .padding(.top, 5.0)
                        .animation(.easeInOut(duration: 0.4), value: total)
                        .opacity(0.7)
                        .foregroundStyle(.thickMaterial)
                        
                }
                .padding(.bottom,-deviceHeight/5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.linearGradient(colors: [Color("NoSheepBG1"),Color("NoSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear() {
            isShow = false
        }
    }
}

struct NoSheepView_Previews: PreviewProvider {
    static var previews: some View {
        NoSheepView()
    }
}
