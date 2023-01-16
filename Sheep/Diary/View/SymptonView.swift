//
//  SymptonView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/16.
//

import SwiftUI
import WrappingStack

struct SymptonView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    let todoItem: TodoListInfo.TodoItem
    @State var symptonList:[String] = []
    
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    
    func fetchSympton() -> [String] {
        var symptonList:[String] = []
        for index in 0..<todoItem.symptom.count{
            if todoItem.symptom[index] {
                if index != todoItem.symptom.count - 1 {
                    symptonList.append(todoItem.symptomName[index])
                } else {
                    symptonList.append(todoItem.otherSym)
                }
            }
        }
        return symptonList
    }
  
    var body: some View {
        WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 8, verticalSpacing: 10) {
            ForEach(fetchSympton(), id: \.self) { item in
                Text(LocalizedStringKey(item))
                    .font(.subheadline)
                    .padding(.all, 8)
                    .background(.thinMaterial)
                    .foregroundColor(Color("TextColor"))
                    .cornerRadius(6)
            }
            
        }
    }

}


struct SymptonView_Previews: PreviewProvider {
    static var previews: some View {
        SymptonView(todoItem: TodoListInfo.TodoItem(
            feeling: "11",
            symptom: [false, true, true, true, true, true, false, false, false, false, true, true],
            otherSym: "421"
        ))
    }
}

