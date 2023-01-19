//
//  NoSheepShareView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/9.
//

import SwiftUI

struct NoSheepShare: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    var totalScore: Int
    var year = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("\(String(year)).\(month).\(day)")
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .frame(width: deviceWidth/1.1, alignment: .leading)
            .foregroundColor(Color("NoSheepColor1"))
            .padding(.top, 52)
            .padding(.leading)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("分享自 别羊App")
                            .fontWeight(.medium)
                        
                        Text("不当小羊人 💪🏻")
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
                VStack {
                    Text("我在“别羊”里戳戳了\(times)次小羊")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("获得了\(totalScore)分")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.bottom, 2)
                    Text("但小羊还是很可爱的")
                        .font(.body)
                    Text("这里仅仅指 “新冠别来!”")
                        .font(.body)
                }
                .padding(.bottom)
                HStack {
                    Image("SharingNoteImg")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("TextColor"))
                        .frame(width: 110)
                        .opacity(0.90)
                        .padding(.horizontal, 15.0)
                    Text("可以用“别羊”App\n记录并分享新冠期间的身体状况和应对方法哦")
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(22)
            .frame(width: deviceWidth/1.1)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.bottom, 42)
            
            HStack(spacing: 12) {
                Image("Icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                VStack(alignment: .leading) {
                    Text("别羊")
                        .font(.title2)
                        .fontWeight(.black)
                    Text("赛博羊木鱼 新冠日记本")
                        .font(.subheadline)
                }
                Spacer()
                Image("QRCode")
                    .resizable()
                    .scaledToFit()
                    .background(.thinMaterial)
                    .frame(width: 55, height: 55)
                    .cornerRadius(6)
            }
            .padding(22)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: deviceWidth/1.1)
            .padding(.bottom)
            
            Image("Store")
            
            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.linearGradient(colors: [Color("NoSheepBG1"),Color("NoSheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        
    }
}

struct NoSheepShareView: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    var totalScore: Int
    
    var body: some View {
        ScrollView {
            NoSheepShare(times: times, totalScore: totalScore)
                .cornerRadius(16)
        }
        .frame(height: deviceHeight/1.23)
        .cornerRadius(16)
    }
}

struct NoSheepShareView_Previews: PreviewProvider {
    static var previews: some View {
        NoSheepShareView(times: 3, totalScore: 3)
    }
}

