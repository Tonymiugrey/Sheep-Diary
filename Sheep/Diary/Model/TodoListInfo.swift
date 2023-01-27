//
//  TodoListInfo.swift
//  SwiftUIList
//
//  Created by Fredrik Eilertsen on 4/10/21.
//

import Foundation
import SwiftUI

struct TodoListInfo: Codable {
    var todos = [TodoItem]()

    struct TodoItem: Codable, Identifiable, Equatable {
        private(set) var id = UUID().uuidString
        var time = Calendar.current
        var year = Calendar.current.component(.year, from: Date())
        var month = Calendar.current.component(.month, from: Date())
        var weekday = Calendar.current.component(.weekday, from: Date())
        var day = Calendar.current.component(.day, from: Date())
        var hour = Calendar.current.component(.hour, from: Date())
        var min = Calendar.current.component(.minute, from: Date())
        
        var feeling = ""
        var testResult = 1
        var symptom = [false, false, false, false, false, false, false, false, false, false, false, false]
        var symptomName = ["无症状", "发烧", "头晕头痛", "咽痛", "鼻塞", "呼吸困难", "心跳快", "腰酸背痛", "失去味觉", "失去嗅觉", "闹肚子", "其他"]
        var temperature = 37.0
        var otherSym = ""
        var isHavingDrug = 0
        var drug = ""
        var others = ""
        var diaryWords = ""
        
        var isCompleted = false
        var dueDate = DueDate(year: 0, month: 0, day: 0, hour: 0, minute: 0)
        private(set) var notificationId = UUID().uuidString
        var hasNotification = false

        var dueDateIsValid: Bool {
            dueDate.toSwiftDate().timeIntervalSinceNow.sign != .minus
        }

        mutating func generateNewId() {
            id = UUID().uuidString
        }

        struct DueDate: Codable, Equatable {
            var year: Int
            var month: Int
            var day: Int
            var hour: Int
            var minute: Int

            func toSwiftDate() -> Date {
                Calendar.current.date(
                    from: DateComponents(
                        year: year,
                        month: month,
                        day: day,
                        hour: hour,
                        minute: minute
                    )
                )!
            }

            func fromSwiftDate(_ date: Date) -> TodoListInfo.TodoItem.DueDate {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                return TodoListInfo.TodoItem.DueDate(
                    year: dateComponents.year!,
                    month: dateComponents.month!,
                    day: dateComponents.day!,
                    hour: dateComponents.hour!,
                    minute: dateComponents.minute!
                )
            }

            func formattedDateString() -> String {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                formatter.timeZone = .current
                return formatter.string(from: toSwiftDate())
            }
        }
    }

    func index(of item: TodoItem) -> Int? {
        todos.firstIndex { $0.id == item.id }
    }

    var json: Data? {
        try? JSONEncoder().encode(self)
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(TodoListInfo.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }

    // To make the SwiftUI preview work we need to use test data
    init(testData: Bool) {
        if !testData {
            loadPersistedJsonData()
        } else {
            loadTestData()
        }
    }

    mutating private func loadPersistedJsonData() {
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("TodoList.json") {
            if let jsonData = try? Data(contentsOf: url), let savedTodoListInfo = TodoListInfo(json: jsonData) {
                self.todos = savedTodoListInfo.todos
            }
        }
    }

    static func persistTodoList(_ todoListInfo: TodoListInfo) {
        if let json = todoListInfo.json, let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("TodoList.json") {
            do {
                try json.write(to: url)
            } catch let error {
                print("Couldn't save, error: \(error)")
            }
        }
    }

    // Test data for SwiftUI preview
    mutating private func loadTestData() {
        self.todos = [
            TodoItem(
                month: 1,
                day: 19,
                feeling: "头好晕",
                testResult: 1,
                symptom: [false, true, true, true, true, false, true, false, false, false, false, false],
                temperature: 38.9,
                isHavingDrug: 1,
                drug: "布洛芬",
                others: "睡了一整天",
                diaryWords: "还是没躲过……\n希望能快快好起来吧"
            ),
            TodoItem(
                month: 1,
                day: 20,
                feeling: "身上开始痛了",
                testResult: 1,
                symptom: [false, true, true, true, true, false, true, false, false, false, false, false],
                temperature: 38.9,
                isHavingDrug: 1,
                drug: "布洛芬",
                others: "睡了一整天",
                diaryWords: "还是没躲过……/n希望能快快好起来吧"
            ),
            TodoItem(
                month: 1,
                day: 21,
                feeling: "退烧了",
                testResult: 1,
                symptom: [false, true, true, true, true, false, true, false, false, false, false, false],
                temperature: 38.9,
                isHavingDrug: 1,
                drug: "布洛芬",
                others: "睡了一整天",
                diaryWords: "还是没躲过……/n希望能快快好起来吧"
            ),
            TodoItem(
                month: 1,
                day: 22,
                feeling: "感觉好多了",
                testResult: 1,
                symptom: [false, true, true, true, true, false, true, false, false, false, false, false],
                temperature: 38.9,
                isHavingDrug: 1,
                drug: "布洛芬",
                others: "睡了一整天",
                diaryWords: "还是没躲过……/n希望能快快好起来吧"
            ),
            TodoItem(
                month: 1,
                day: 23,
                feeling: "终于转阴 还有点咳",
                testResult: 0,
                symptom: [false, false, false, true, false, false, false, false, false, false, false, false],
                isHavingDrug: 0
                )
        ]
    }
}

