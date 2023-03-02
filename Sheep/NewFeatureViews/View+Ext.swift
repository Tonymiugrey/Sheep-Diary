//
//  View+Ext.swift
//  NewFeaturesSwiftUI
//
//  Created by Roddy Munro on 13/02/2021.
//

import SwiftUI

extension View {
    
    public var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
