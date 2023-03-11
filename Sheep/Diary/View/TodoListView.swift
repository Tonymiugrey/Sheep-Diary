//
//  TodoListView.swift
//  SwiftUIList
//
//  Created by miuGrey on 2022/12/31.
//

import SwiftUI
import StoreKit

struct TodoListView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    @EnvironmentObject var store: Store
    @State var searchText = ""
    @State var isShowingDeleteItemsConfirmationDialog = false
    @State var showEditingPage = false
    @State var showSharingView = false
    
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        if input >= 27 && reviewHasShown == false{
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    private var searchBinding: Binding<String> {
        Binding<String>(
            get: { return self.searchText },
            set: { newSearchText in
                withAnimation {
                    self.searchText = newSearchText
                }
            }
        )
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.todoListIsEmpty {
                    ZStack {
                        VStack {
                            Image("Diary")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 300)
                            Text("记录下你今天的感受\n和应对方法吧")
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .lineSpacing(5)
                                .font(.title)
                            Text("如果需要，您可以在就医时提供这些记录\n您也可以选择分享这段经历\n让更多人在看到之后也能镇定地去面对")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.top, 2.0)
                                .lineSpacing(5)
                        }
                        .padding(.bottom, 120)
                        
                        if store.purchasedProd.count == 0 {
                            SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-6106285619802028/5734478761")
                        }
                    }
                } else {
                    ZStack {
                        List {
                            ForEach(viewModel.filteredListOfTodosByTitle(searchText)) { todoItem in
                                NavigationLink {
                                    DiaryContentView(todoItem: todoItem)
                                        .hiddenTabBar()
                                        .environmentObject(viewModel)
                                        .environmentObject(store)
                                } label: {
                                    ListItemView(todoItem: todoItem)
                                }
                            }
                            .onDelete {
                                viewModel.remove(indexSet: $0)
                            }
                        }
                        .searchable(text: searchBinding)
                        if store.purchasedProd.count == 0 {
                            SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-3240610254201173/1343771566")
                        }
                    }
                }
            }
        }
        .navigationTitle("小羊日记")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showEditingPage = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .frame(width: 30, height: 30)
                }
                .sheet(isPresented: self.$showEditingPage) {
                    AddEditTodoView(todoItem: TodoListInfo.TodoItem())
                        .environmentObject(store)
                        .onDisappear() {
                            RandomRate(input: CGFloat.random(in: 0...35))
                        }
                }
            }
        }
    }
}


struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            TodoListView()
                .environmentObject(TodoListViewModel(testData: true))
                .environmentObject(Store())
                .tint(Color("SheepColor"))
        }
    }
}
