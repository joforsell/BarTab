//
//  CustomTabBarContainerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-05.
//

import SwiftUI
import SwiftUIX

struct CustomTabBarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    
    @State private var tabs = [TabBarItem]()
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
                GeometryReader { _ in
                    VStack {
                        Spacer()
                        CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
        }
    }
}
