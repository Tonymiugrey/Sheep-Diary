//
//  DiaryShareView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/17.
//

import SwiftUI

struct DiaryShareView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    let todoItem: TodoListInfo.TodoItem
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(String(todoItem.year)).\(todoItem.month).\(todoItem.day)")
                        .fontWeight(.heavy)
                        .font(.title2)
                        .foregroundColor((Color("SheepColor1")))
                    Text("小羊日记")
                        .fontWeight(.heavy)
                        .font(.system(size: 42))
                        .foregroundColor((Color("SheepColor1")))
                    Text("使用 别羊App 记录")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor((Color("SheepColor1")))
                }
                .padding(.top, 72)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("💭 \(todoItem.feeling)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            if todoItem.testResult == 0 {
                                Text("🧪 检测结果：阴性")
                                    .font(.title2)
                                    .fontWeight(.medium)
                            } else {
                                Text("🧪 检测结果：阳性")
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            Text("🤧症状")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            SymptonView(todoItem: todoItem)
                        }
                        
                        if todoItem.symptom[1] {
                            Text("🌡️体温：\(todoItem.temperature, specifier: "%g")℃")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                            
                        if todoItem.isHavingDrug == 0 {
                            Text("💊用药：无")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        else {
                            Text("💊用药：\(todoItem.drug)")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        
                        if todoItem.others != "" {
                            Text("☑️其他措施：\(todoItem.others)")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(22)
                    .frame(width: deviceWidth/1.1, alignment: .leading)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    
                    if todoItem.diaryWords != "" {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("📝日记：")
                                .fontWeight(.medium)
                                .font(.title2)
                            Text(todoItem.diaryWords)
                                .font(.body)
                                .padding(.leading, 10)
                        }
                        .padding(22)
                        .frame(width: deviceWidth/1.1, alignment: .leading)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        
                    }
                }
                
            }
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
                    .frame(width: 55, height: 55)
                    .cornerRadius(6)
            }
            .padding(22)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: deviceWidth/1.1)
            
            Spacer(minLength: 50
            )

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.linearGradient(colors: [Color("SheepBG1"),Color("SheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        
    }
}

struct DiaryShareScorllableView: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    let todoItem: TodoListInfo.TodoItem
    
    var body: some View {
        ScrollView {
            DiaryShareView(todoItem: todoItem)
                    .cornerRadius(16)
        }
        .frame(height: deviceHeight/1.3)
        .cornerRadius(16)
    }
}

struct DiaryShareView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryShareScorllableView(todoItem: TodoListInfo.TodoItem(
            feeling: "防护带",
            symptom: [false, true, true, true, true, true, false, false, false, false, true, false],
            others: "321fdn",
            diaryWords: "fewbafbewafbewa"
        ))
    }
}
