//
//  AddEditTodoView.swift
//  SwiftUIList
//
//  Created by miuGrey on 2022/12/29.
//

import SwiftUI
import UserNotifications
import StoreKit
import WrappingStack

struct AddEditTodoView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var todoItem: TodoListInfo.TodoItem
    @State private var showNotificationExpiredDialog = false
    @State private var notificationIsNotAuthorized = false
    @State private var insertOrUpdateNotification = false
    let generator = UINotificationFeedbackGenerator()
    
    let step = 0.1
    let range = 35.0...42.0
    
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        //let luckyNum = input.truncatingRemainder(dividingBy: 7)
        if input >= 27 && reviewHasShown == false {
            print("Please Rate")
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("感受（必填）")) {
                    TextField("今天感觉怎么样？", text: $todoItem.feeling)
                }
                
                Section(header: Text("检测结果")) {
                    HStack {
                        Text("检测结果是")
                        Picker("检测结果是", selection: $todoItem.testResult) {
                            Text("阴性").tag(0)
                            Text("阳性").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 100)
                    }
                }
                
                Section(header: Text("症状（必填）")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HStack {
                                ForEach(0..<6) { i in
                                    Toggle(isOn: $todoItem.symptom[i]) {
                                        Text(LocalizedStringKey(todoItem.symptomName[i]))
                                    }
                                    .background(todoItem.symptom[i] ? Color("SheepColor") : Color("BGColor"))
                                    .foregroundColor(todoItem.symptom[i] ? Color(.white) : Color("SheepColor"))
                                    .cornerRadius(8)
                                    .toggleStyle(ButtonToggleStyle())
                                }
                            }
                            HStack {
                                ForEach(6..<12) { i in
                                    Toggle(isOn: $todoItem.symptom[i]) {
                                        Text(LocalizedStringKey(todoItem.symptomName[i]))
                                    }
                                    .background(todoItem.symptom[i] ? Color("SheepColor") : Color("BGColor"))
                                    .foregroundColor(todoItem.symptom[i] ? Color(.white) : Color("SheepColor"))
                                    .cornerRadius(8)
                                    .toggleStyle(ButtonToggleStyle())
                                }
                            }
                        }
                    }
                    .padding(.vertical, 2)
                    
                    if todoItem.symptom[1] {
                        VStack {
                            Slider(value: $todoItem.temperature, in: range, step: step, minimumValueLabel: Text("35.0"), maximumValueLabel: Text("42.0")) {
                                Text("\(todoItem.temperature, specifier: "%g")℃")
                            }
                            Text("体温 \(todoItem.temperature, specifier: "%g")℃")
                        }
                        
                    }
                    
                    if todoItem.symptom[11] {
                        TextField("写下其他症状", text: $todoItem.otherSym)
                    }
                }
                
                Section(header: Text("用药")) {
                    HStack {
                        Text("有吃药吗？")
                        Picker(selection: $todoItem.isHavingDrug, label: Text("有吃药吗？")) {
                            //每个选项
                            Text("没有").tag(0)
                            Text("有").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 117)
                    }
                    
                    if todoItem.isHavingDrug == 1 {
                        TextField("吃了什么药？", text: $todoItem.drug)
                    }
                }
                
                if todoItem.isHavingDrug == 1 {
                    Section(header: Text("吃药提醒")) {
                        ReminderSectionView(todoItem: $todoItem, insertOrUpdateNotification: $insertOrUpdateNotification)
                    }.alert(isPresented: $notificationIsNotAuthorized) {
                        Alert(title: Text("你没有允许小羊日记推送通知呢，去系统设置里看看吧！"))
                    }
                }
                
                Section(header: Text("其他措施")) {
                    TextField("多喝水？还是睡了一天？", text: $todoItem.others)
                }
                
                Section(header: Text("日记")) {
                    TextEditor(text: $todoItem.diaryWords)
                        .frame(height:80)
                }
                
                Section(header: Text("广告")) {
                    NativeContentView()
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .navigationTitle(Text("写日记"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        self.presentationMode.wrappedValue.dismiss()
                        //RandomRate(input: CGFloat.random(in: 8...19))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        handleDonePressed()
                        self.generator.notificationOccurred(.success)
                    }
                    .disabled(todoItem.feeling.isEmpty || todoItem.symptom.allSatisfy({$0 == false}))
                }
            }
            // In SwiftUI we cannot attach 2 alerts at the same place, so one is attached here, and the other to the reminder section
            .alert(isPresented: $showNotificationExpiredDialog) {
                Alert(title: Text("提醒的时间不能早于当前时间哦"))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(Color("SheepColor"))
    }

    private struct ReminderSectionView: View {
        @Binding var todoItem: TodoListInfo.TodoItem
        @Binding var insertOrUpdateNotification: Bool

        private var dateSelected: Binding<Date> {
            Binding<Date>(
                get: { return todoItem.dueDate.toSwiftDate() },
                set: { date in
                    todoItem.dueDate = todoItem.dueDate.fromSwiftDate(date)
                }
            )
        }

        var body: some View {
            if (todoItem.dueDateIsValid && todoItem.hasNotification) || insertOrUpdateNotification {
                DatePicker("吃药提醒", selection: dateSelected, in: Date()...).labelsHidden()
            }

            Button((todoItem.dueDateIsValid && todoItem.hasNotification) || insertOrUpdateNotification ? "删除提醒" : "点这里设置") {
                withAnimation(.easeInOut) {
                    if !todoItem.dueDateIsValid {
                        todoItem.dueDate = todoItem.dueDate.fromSwiftDate(Date()) // Set initial date to the current date
                    }

                    // In case we press remove on an existing notificaiton, reset values to false
                    if (todoItem.hasNotification) {
                        todoItem.hasNotification = false
                        insertOrUpdateNotification = false
                    } else {
                        insertOrUpdateNotification.toggle()
                    }
                }
            }
        }
    }

    private func handleDonePressed() {
        if insertOrUpdateNotification && !todoItem.dueDateIsValid {
            showNotificationExpiredDialog = true
        } else {
            if insertOrUpdateNotification && todoItem.dueDateIsValid {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                        upsertItemAndPopView()
                    } else if settings.authorizationStatus == .notDetermined {
                        requestNotificaitonAuthorization {
                            upsertItemAndPopView()
                        }
                    } else {
                        // The user has previously denied the permission
                        notificationIsNotAuthorized = true
                    }
                }
            } else {
                upsertItemAndPopView()
            }
        }
    }

    private func upsertItemAndPopView() {
        if !todoItem.dueDateIsValid {
            todoItem.hasNotification = false
        } else if insertOrUpdateNotification {
            todoItem.hasNotification = true
        }

        DispatchQueue.main.async {
            viewModel.upsert(editedItem: todoItem)
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func requestNotificaitonAuthorization(successHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    successHandler()
                } else if let error = error {
                    print(error.localizedDescription)
                    notificationIsNotAuthorized = true
                }
            }
    }
}

struct AddEditTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditTodoView(
            todoItem: TodoListInfo.TodoItem()
        )
    }
}
