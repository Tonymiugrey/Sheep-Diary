//
//  ListItemView.swift
//  SwiftUIList
//
//  Created by Fredrik Eilertsen on 4/18/21.
//

import SwiftUI
import StoreKit

struct ListItemView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    let todoItem: TodoListInfo.TodoItem
    @State var showEditingPage = false
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        if input >= 27 && reviewHasShown == false{
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
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
            Text(isPos())
                .font(.title)
                .padding(.all, 5)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(todoItem.month)月\(todoItem.day)日 \(todoItem.feeling)")
                    .foregroundColor(Color("TextColor"))
                    .fontWeight(.medium)
                    .font(.title3)

                if todoItem.hasNotification && todoItem.dueDateIsValid {
                    Text(todoItem.dueDate.formattedDateString()).font(.caption)
                }
            }
        }
        .padding(8)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(
            todoItem: TodoListInfo.TodoItem(
                testResult: 0
            )
        )

        ListItemView(
            todoItem: TodoListInfo.TodoItem(
                testResult: 1
            )
        )
    }
}
