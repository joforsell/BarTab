//
//  CustomTabBarView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-02.
//

import SwiftUI
import SwiftUIX

struct CustomTabBarView: View {
    var tabs = [TabBarItem]()
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    @Namespace private var tabBarNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.gray.opacity(0.3))
            HStack(alignment: .bottom) {
                ForEach(TabBarItem.allCases, id: \.self) { tab in
                    tabView(tab: tab)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            switchToTab(tab: tab)
                        }
                }
            }
            .onChange(of: selection) { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark).ignoresSafeArea())
    }
}

extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            tab.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: tab == .drinks ? 34 : 28)
                .padding(.bottom, 2)
                .foregroundColor(localSelection == tab ? .accentColor : .gray)
                .overlay(alignment: .bottom) {
                    if localSelection == tab {
                        Rectangle()
                            .frame(width: 44, height: 2)
                            .foregroundColor(.accentColor)
                            .offset(y: 4)
                            .matchedGeometryEffect(id: "tab_underline", in: tabBarNamespace)
                    }
                }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}
