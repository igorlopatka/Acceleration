//
//  UnitSymbolView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 24/11/2022.
//

import SwiftUI

struct UnitSymbolView: View {
    
    let symbolName: String
    
    var body: some View {
        Image(systemName: symbolName)
            .resizable()
            .frame(width: 40, height: 40)
    }
}
