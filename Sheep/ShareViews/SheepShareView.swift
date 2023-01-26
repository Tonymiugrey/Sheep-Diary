//
//  SheepShareView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/9.
//

import SwiftUI

struct SheepShare: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    var year = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())

    var body: some View {
        let diaries = viewModel.filteredListOfTodosByTitle("")
        
        VStack {
            VStack(alignment: .leading) {
                Text("\(String(year)).\(month).\(day)")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .padding(.bottom, 4)
                Label("该内容为用户自行分享，与“小羊日记”及其开发者无关。请谨慎辨别内容真伪！", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
            }
            .frame(width: deviceWidth/1.1, alignment: .leading)
            .foregroundColor(Color("SheepColor1"))
            .padding(.top, 52)
            .padding(.leading)
            .padding(.bottom, 12)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("分享自 小羊日记App")
                                .fontWeight(.medium)
                            
                            if viewModel.todoListIsEmpty {
                                Text("难逃一羊 🤒")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            else {
                                let lastDiary = diaries.last!
                                if lastDiary.testResult == 1 {
                                    Text("羊的第\(diaries.count)天")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                } else if lastDiary.testResult == 0 {
                                    Text("终于转阴 🥳")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        //.padding(.bottom, 8)
                                    Text("全程\(diaries.count)天")
                                        .font(.title)
                                        .fontWeight(.medium)
                                        .padding(.bottom, 5)
                                }
                            }

                    }
                        Spacer()
                        Image("Sheep")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 90, maxHeight: 90)
                            .rotationEffect(.degrees(15))
                            .offset(x:0, y:5)
                    }
                    
                    if viewModel.todoListIsEmpty == false {
                        let lastDiary = diaries.last!
                        VStack(alignment: .leading, spacing: 4) {
                            Text("📝 今日感受")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            Text(lastDiary.feeling)
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            if lastDiary.testResult == 1 {
                                Text("🤧 症状")
                                    .fontWeight(.bold)
                                    .font(.title2)
                                    .padding(.top, 10)
                                
                                SymptonView(todoItem: lastDiary)
                                    .padding(.top, 8)
                            }
                    }
                        .padding(.top, 8)
                    }
                }
                .padding(22)
                .frame(width: deviceWidth/1.1)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack {
                    VStack {
                        Text("我在“小羊日记”里撸了\(times)次小羊")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.bottom, 1)
                        Text("希望快快好起来！")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
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
            }
            
            VStack(spacing: 24) {
                HStack(spacing: 12) {
                    Image("Icon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    VStack(alignment: .leading, spacing: 3) {
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
        .background(.linearGradient(colors: [Color("SheepBG1"),Color("SheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        
    }
}

struct SheepShareView: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    var times: Int
    
    var body: some View {
        ScrollView {
            SheepShare(times: times)
                .environmentObject(TodoListViewModel(testData: false))
                .cornerRadius(16)
        }
        .frame(height: deviceHeight/1.3)
        .cornerRadius(16)
    }
}

struct SheepShareView_Previews: PreviewProvider {
    static var previews: some View {
        SheepShareView(times: 3)
    }
}

