//
//  NewFeaturesAlertView.swift
//  NewFeaturesSwiftUI
//
//  Created by Roddy Munro on 13/02/2021.
//

import SwiftUI

struct NewFeaturesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let newFeatures: [NewFeature] = [
        .init(iconName: "bed.double.fill", title: "数羊", description: "睡不着的时候就来数数羊吧！您可以在“放松”功能右下角的按钮里发现它，随后点击小羊试试！"),
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: isPad ? 64 : 48) {
                    Text("新功能！")
                        .titleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.top, isPad ? 80 : 48)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(newFeatures, content: NewFeatureRow.init)
                    }
                }
                .padding()
            }
            
            Button(action: { presentationMode.wrappedValue.dismiss() }, label: { Text("继续") }).buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, isPad ? 64 : 32)
        }
        .padding(.horizontal, isPad ? 128 : 24)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct NewFeaturesView_Preview: PreviewProvider {
    static var previews: some View {
        NewFeaturesView()
    }
}
