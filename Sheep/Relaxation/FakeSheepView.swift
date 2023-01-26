//
//  FakeSheepView.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/30.
//

import SwiftUI
import StoreKit

struct FakeSheepView: View {
    private var title:LocalizedStringKey = "幻羊"
    private var subTitle:LocalizedStringKey = "应该只是幻觉啦~"
    @State private var total = 0
    @State private var once = 1
    @State private var isTapped = false
    @State private var isMoving = false
    @State var isShow = true
    @State private var sheepScale = CGFloat.random(in: (0.4)...(1.3))
    private var deviceHeight = UIScreen.main.bounds.height
    private var deviceWidth = UIScreen.main.bounds.width
    @State var showSharingView = false
    let generator = UINotificationFeedbackGenerator()
    
    @State var reviewHasShown = false
    func RandomRate() {
        if total == 100 && reviewHasShown == false {
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
                                ShareContentView(viewToShot: FakeSheepShare(times: total)
                                    .environmentObject(TodoListViewModel(testData: false)), title: "幻羊 - 分享自 小羊日记App")
                                .foregroundColor(Color("TextColor"))
                            }
                        }
                        
                        Text(subTitle)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
                .foregroundColor((Color("FakeSheepColor1")))
                .frame(width: deviceWidth, alignment: .leading)
                .padding(.leading, deviceWidth/10)
                .padding(.top, deviceHeight/20)

                ZStack {
                    Image("Sheep") // Sheep 0
                        .resizable()
                        .scaledToFit()
                        .position(x: deviceWidth/3 + CGFloat.random(in: -deviceWidth/2.2...deviceWidth/3.8), y: deviceHeight/3 + CGFloat.random(in: -deviceHeight/5...deviceHeight/5.5))
                        .frame(width: 200)
                        .scaleEffect(isTapped ? sheepScale - 0.2 : sheepScale)
                        .opacity(isMoving ? 0.4 : 1)
                        .blur(radius: isMoving ? 5 : 0)
                        .animation(.easeInOut(duration: 0.2))
                        .onTapGesture {
                            if isMoving == false {
                                self.generator.notificationOccurred(.warning)
                                total += once
                                RandomRate()
                                withAnimation {
                                    isTapped.toggle()
                                    isMoving.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        isTapped.toggle()
                                        sheepScale = CGFloat.random(in: (0.4)...(1.1))
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isMoving.toggle()
                                    }
                                }
                            }
                            
                        }
                }
                
                Text("戳羊\(total)次")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("FakeSheepColor2"))
                    .padding(.bottom, deviceHeight/10)
                    .animation(.easeInOut(duration: 0.4), value: total)
                    .opacity(0.7)
                
            }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.linearGradient(colors: [Color("FakeSheepBG1"),Color("FakeSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            isShow = true
        }
        .onDisappear() {
            isShow = false
        }
    }
    
}

struct FakeSheepView_Previews: PreviewProvider {
    static var previews: some View {
        FakeSheepView()
            //.previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}