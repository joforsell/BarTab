//
//  BodyView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-30.
//

import SwiftUI

struct BodyView: View {
    var body: some View {
        HStack {
            OrderView()
            CustomerListView()
        }
    }
}

struct BodyView_Previews: PreviewProvider {
    static var previews: some View {
        BodyView()
    }
}
