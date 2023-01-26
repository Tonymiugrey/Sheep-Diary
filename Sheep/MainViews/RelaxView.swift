//
//  RelaxView.swift
//  Sheep
//
//  Created by miuGrey on 2023/1/26.
//

import SwiftUI

struct RelaxView: View {
    @State var pickerValue = 0
    @State var isShow = true
    var deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            SheepView()
                .opacity(pickerValue == 2 ? 1.0 : 0.0)
            
            FakeSheepView()
                .opacity(pickerValue == 1 ? 1.0 : 0.0)
            
            NoSheepView(isShowBinding: $isShow)
                .opacity(pickerValue == 0 ? 1.0 : 0.0)
                .onChange(of: pickerValue, perform: { value in
                    if value != 0 {
                        print(isShow)
                        isShow = false
                    } else {
                        isShow = true
                    }
                })

            
            Picker(selection: $pickerValue, label: Text("Picker")) {
                Text("1")
                    .tag(0)
                Text("1").tag(1)
                Text("2").tag(2)
            }
            .pickerStyle(.segmented)
            .background(.thinMaterial)
            .cornerRadius(8)
            .padding(.all)
            .padding(.top, deviceHeight/1.3)
        }
        .onDisappear() {
            isShow = false
        }
    }
}

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        RelaxView()
    }
}
