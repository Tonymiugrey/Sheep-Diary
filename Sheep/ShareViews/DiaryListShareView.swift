//
//  DiaryListShareView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/9.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    let todoItem: TodoListInfo.TodoItem
    
    private func isPos() -> String {
        if todoItem.testResult == 1 {
            return "🐑"
        }
        else {
            return "✔️"
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("\(todoItem.month)月\(todoItem.day)日 \(todoItem.feeling)")
                            .foregroundColor(Color("TextColor"))
                            .fontWeight(.semibold)
                            .font(.title)
                        Spacer()
                        Text(isPos())
                            .font(.title)
                            .padding(.all, 5)
                    }
                    VStack (alignment: .leading) {
                        Text("🤧症状：")
                            .fontWeight(.medium)
                            .font(.title3)
                        SymptonView(todoItem: todoItem)
                            .padding(.bottom, 3)
                    }
                    
                    if todoItem.symptom[1] {
                        Text("🌡️体温：\(todoItem.temperature, specifier: "%g")℃")
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                        
                    if todoItem.isHavingDrug == 0 {
                        Text("💊用药：无")
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                    else {
                        Text("💊用药：\(todoItem.drug)")
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                    
                    if todoItem.others != "" {
                        Text("☑️其他措施：\(todoItem.others)")
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                }
                .padding(6)
                
                if todoItem.diaryWords != "" {
                    Text("📝日记：")
                        .fontWeight(.medium)
                        .font(.title3)
                        .padding([.leading,.bottom], 3)
                    Text(todoItem.diaryWords)
                        .padding(.leading, 10)
                }
            }
            Spacer()
        }

    }
}

struct DiaryListShareView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    @State private var searchText = ""
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("小羊日记")
                        .fontWeight(.heavy)
                        .font(.system(size: 46))
                    Text("使用 别羊App 记录")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.bottom, 2)
                    Label("该内容为用户自行分享，与“别羊”及其开发者无关。请谨慎辨别内容真假！", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                }
                .foregroundColor((Color("SheepColor1")))
                .frame(width: deviceWidth/1.1, alignment: .leading)
                .padding(.top, 72)

                ForEach(viewModel.filteredListOfTodosByTitle(searchText)) { todoItem in
                    ItemView(todoItem: todoItem)
                        .padding(22)
                        .frame(width: deviceWidth/1.1)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
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
        .background(.linearGradient(colors: [Color("SheepBG1"),Color("SheepBG2")], startPoint: .topTrailing, endPoint: .bottomLeading))
        
    }
}

struct DiaryListShareScorllableView: View {
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ScrollView {
            DiaryListShareView()
                    .environmentObject(TodoListViewModel(testData: false))
                    .cornerRadius(16)
        }
        .frame(height: deviceHeight/1.3)
        .cornerRadius(16)
    }
}

struct DiaryListShareView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListShareScorllableView()
    }
}
