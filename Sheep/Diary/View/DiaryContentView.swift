//
//  DiaryContentView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/4.
//

import SwiftUI

struct DiaryContentView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    let todoItem: TodoListInfo.TodoItem
    @State var symptonList:[String] = []
    @State var showEditingPage = false
    @State var showSharingView = false
    
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack() {
            HStack {
                Text("💭 \(todoItem.feeling)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.leading, deviceWidth/23)
                Spacer()
            }
            .padding(.vertical, 8)
            
            ScrollView() {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 14) {
                            if todoItem.testResult == 0 {
                                Text("🧪 检测结果：阴性")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            } else {
                                Text("🧪 检测结果：阳性")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            Text("🤧症状")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            SymptonView(todoItem: todoItem)
                        }
                        
                        if todoItem.symptom[1] {
                            Text("🌡️体温：\(todoItem.temperature, specifier: "%g")℃")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                            
                        if todoItem.isHavingDrug == 0 {
                            Text("💊用药：无")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        else {
                            Text("💊用药：\(todoItem.drug)")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        if todoItem.others != "" {
                            Text("☑️其他措施：\(todoItem.others)")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(22)
                    .frame(width: deviceWidth/1.1, alignment: .leading)
                    .background(Color("FGColor"))
                    .cornerRadius(20)
                    
                    if todoItem.diaryWords != "" {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("📝日记：")
                                .fontWeight(.semibold)
                                .font(.title2)
                            Text(todoItem.diaryWords)
                                .font(.body)
                                .padding(.leading, 10)
                        }
                        .padding(22)
                        .frame(width: deviceWidth/1.1, alignment: .leading)
                        .background(Color("FGColor"))
                        .cornerRadius(20)
                        
                    }
                    
                    NativeContentView()
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .padding(22)
                        .frame(width: deviceWidth/1.1, alignment: .leading)
                        .background(Color("FGColor"))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            
        }
        .background(Color("DiaryBG"))
        .navigationTitle("\(todoItem.month)月\(todoItem.day)日")
        .toolbar() {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showSharingView = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .fullScreenCover(isPresented: $showSharingView)
                {
                    ShareContentView(viewToShot: DiaryShareView(todoItem: todoItem), title: "小羊日记 \(String(todoItem.year)).\(todoItem.month).\(todoItem.day) - 分享自 别羊App")
                    .foregroundColor(Color("TextColor"))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("编辑") {
                    self.showEditingPage = true
                }
                .sheet(isPresented: self.$showEditingPage) {
                    AddEditTodoView(todoItem: todoItem)
                }
            }
        }
            
    }
}

struct DiaryContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiaryContentView(
                todoItem: TodoListInfo.TodoItem(
                    feeling: "防护带",
                    symptom: [false, true, true, true, true, true, false, false, false, false, true, false],
                    others: "321fdn",
                    diaryWords: "fewbafbewafbewa"
                )
            )
            .environmentObject(TodoListViewModel(testData: false))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
