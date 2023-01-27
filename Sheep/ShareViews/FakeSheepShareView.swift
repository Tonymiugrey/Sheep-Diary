//
//  FakeSheepShareView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/9.
//

import SwiftUI

struct FakeSheepShare: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    var year = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())

    var body: some View {
        VStack {
            Text("\(String(year)).\(month).\(day)")
                .font(.title2)
                .fontWeight(.heavy)
                .frame(width: deviceWidth/1.1, alignment: .leading)
                //.foregroundStyle(.regularMaterial)
                .foregroundColor(Color("FakeSheepColor1"))
                .padding(.top, 52)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("分享自 小羊日记App")
                            .fontWeight(.medium)
                        
                        Text("幻羊中 😶‍🌫️")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Image("Sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .rotationEffect(.degrees(15))
                        .offset(x:0, y:5)
                }
            }
            .padding(22)
            .frame(width: deviceWidth/1.1)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.bottom, 12)
            
            VStack {
                Text("我在“小羊日记”里戳戳了\(times)次小羊\n应该只是幻觉啦~")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                
                HStack {
                    Image("SharingNoteImg")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .opacity(0.9)
                        .padding(.horizontal, 15.0)
                    Text("可以用“小羊日记”App\n记录并分享感染期间的身体状况和应对方法哦")
                        .fontWeight(.medium)
                        .lineLimit(5)
                        .frame(height: 180)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(22)
            .frame(width: deviceWidth/1.1)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.bottom, 42)
            
            VStack(spacing: 24) {
                HStack(spacing: 12) {
                    Image("Icon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    VStack(alignment: .leading) {
                        Text("小羊日记")
                            .font(.title2)
                            .fontWeight(.black)
                        Text("症状日记本 压力释放所")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .padding(22)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: deviceWidth/1.1)
                
                HStack(spacing: 32) {
                    Spacer()
                    Image("Store")
                    Image("QRCode")
                        .resizable()
                        .scaledToFit()
                        .background(.thinMaterial)
                        .frame(width: 90, height: 90)
                        .cornerRadius(12)
                    Spacer()
                }
                .padding(12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: deviceWidth/1.1)
                .padding(.bottom)
            }
            
            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.linearGradient(colors: [Color("FakeSheepBG1"),Color("FakeSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        
    }
}

struct FakeSheepShareView: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    
    var body: some View {
        ScrollView {
            FakeSheepShare(times: times)
                .cornerRadius(16)
        }
        .frame(height: deviceHeight/1.23)
        .cornerRadius(16)
    }
}

struct FakeSheepShareView_Previews: PreviewProvider {
    static var previews: some View {
        FakeSheepShareView(times: 3)
    }
}

