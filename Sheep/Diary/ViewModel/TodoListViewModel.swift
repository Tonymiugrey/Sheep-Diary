//
//  TodoListViewModel.swift
//  SwiftUIList
//
//  Created by Fredrik Eilertsen on 4/10/21.
//

import Foundation
import UserNotifications

class TodoListViewModel: ObservableObject {
    @Published private var todoListInfo: TodoListInfo {
        didSet {
            TodoListInfo.persistTodoList(todoListInfo)
        }
    }

    init(testData: Bool = false) {
        todoListInfo = TodoListInfo(testData: testData)
    }

    var todoListIsEmpty: Bool {
        todoListInfo.todos.isEmpty
    }

    var todoListHasNoCompletedItems: Bool {
        todoListInfo.todos.filter { $0.isCompleted }.isEmpty
    }

    func filteredListOfTodosByTitle(_ searchText: String) -> [TodoListInfo.TodoItem] {
        todoListInfo.todos.filter {
            searchText.isEmpty || String($0.year).contains(searchText) || String($0.month).contains(searchText) || String($0.day).contains(searchText) || $0.feeling.lowercased().contains(searchText.lowercased()) || $0.otherSym.lowercased().contains(searchText.lowercased()) || $0.others.lowercased().contains(searchText.lowercased()) || $0.diaryWords.lowercased().contains(searchText.lowercased())
        }.sorted { calculateSortedBy($0, $1) }
    }

    func upsert(editedItem: TodoListInfo.TodoItem) {
        if let itemIndex = todoListInfo.index(of: editedItem) {
            // Remove existing notification when updating with a new one or simply removing the existing
            if todoListInfo.todos[itemIndex].hasNotification && (!editedItem.hasNotification || todoListInfo.todos[itemIndex].dueDate != editedItem.dueDate) {
                removeNotificationIfPresent(for: todoListInfo.todos[itemIndex])
            }

            addNotification(for: editedItem)
            todoListInfo.todos[itemIndex] = editedItem
        } else {
            addNotification(for: editedItem)
            todoListInfo.todos.append(editedItem)
        }
    }

    func remove(indexSet: IndexSet) {
        // Make sure the list is sorted, as it is in the UI
        todoListInfo.todos.sort { calculateSortedBy($0, $1) }

        indexSet.forEach {
            removeNotificationIfPresent(for: todoListInfo.todos[$0])
        }

        todoListInfo.todos.remove(atOffsets: indexSet)
    }

    func removeCompleted() {
        todoListInfo.todos = todoListInfo.todos.filter {
            if $0.isCompleted {
                removeNotificationIfPresent(for: $0)
                return false
            } else {
                return true
            }
        }
    }

    func removeAll() {
        todoListInfo.todos.forEach {
            removeNotificationIfPresent(for: $0)
        }

        todoListInfo.todos = []
    }

    private func removeNotificationIfPresent(for item: TodoListInfo.TodoItem) {
        if item.hasNotification && item.dueDateIsValid {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.notificationId])

            if let itemIndex = todoListInfo.index(of: item) {
                todoListInfo.todos[itemIndex].hasNotification = false
            }
        }
    }

    private func addNotification(for item: TodoListInfo.TodoItem) {
        guard item.hasNotification else { return }

        let content = UNMutableNotificationContent()
        content.title = "小羊日记"
        content.body = "记得吃\(item.drug)!"
        content.sound = .default

        UNUserNotificationCenter.current().add(
            UNNotificationRequest(
                identifier: item.notificationId,
                content: content,
                trigger: UNCalendarNotificationTrigger(
                    dateMatching: DateComponents(
                        year: item.dueDate.year,
                        month: item.dueDate.month,
                        day: item.dueDate.day,
                        hour: item.dueDate.hour,
                        minute: item.dueDate.minute
                    ),
                    repeats: false
                )
            )
        ) { (error) in
            if error != nil {
                // Some error happened, resetting notification id
                if let itemIndex = self.todoListInfo.index(of: item) {
                    self.todoListInfo.todos[itemIndex].hasNotification = false
                }
            }
        }
    }

    func setCompletedState(for item: TodoListInfo.TodoItem, isCompleted: Bool) {
        if let itemIndex = todoListInfo.index(of: item) {
            todoListInfo.todos[itemIndex].isCompleted = isCompleted

            if isCompleted {
                removeNotificationIfPresent(for: item)
            }
        }
    }

    private func calculateSortedBy(_ todoItemLeft: TodoListInfo.TodoItem, _ todoItemRight: TodoListInfo.TodoItem) -> Bool {
        if todoItemLeft.isCompleted != todoItemRight.isCompleted {
            return !todoItemLeft.isCompleted
        } else if todoItemLeft.year != todoItemRight.year {
            return todoItemLeft.year < todoItemRight.year
        } else if todoItemLeft.month != todoItemRight.month {
            return todoItemLeft.month < todoItemRight.month
        } else if todoItemLeft.day != todoItemRight.day {
            return todoItemLeft.day < todoItemRight.day
        } else if todoItemLeft.hour != todoItemRight.hour {
            return todoItemLeft.hour < todoItemRight.hour
        } else if todoItemLeft.min != todoItemRight.min {
            return todoItemLeft.min < todoItemRight.min
        } else {
            return true
        }
    }
}
