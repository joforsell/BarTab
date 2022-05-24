//
//  NumPadView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-22.
//

import SwiftUI
import SwiftUIX

struct NumPadView: View {
    @Binding var balanceAdjustment: String
    @Binding var showingNumpad: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Button {
                withAnimation {
                    showingNumpad.toggle()
                }
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .foregroundColor(.white)
                    .padding()
            }
            .contentShape(Rectangle())
            firstRow
            secondRow
            thirdRow
            fourthRow
        }
        .foregroundColor(.black)
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
    
    private var firstRow: some View {
        HStack(spacing: 2) {
            Button {
                balanceAdjustment.append("1")
            } label: {
                background
                    .overlay(showing("1"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("2")
            } label: {
                background
                    .overlay(showing("2"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("3")
            } label: {
                background
                    .overlay(showing("3"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var secondRow: some View {
        HStack(spacing: 2) {
            Button {
                balanceAdjustment.append("4")
            } label: {
                background
                    .overlay(showing("4"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("5")
            } label: {
                background
                    .overlay(showing("5"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("6")
            } label: {
                background
                    .overlay(showing("6"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var thirdRow: some View {
        HStack(spacing: 2) {
            Button {
                balanceAdjustment.append("7")
            } label: {
                background
                    .overlay(showing("7"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("8")
            } label: {
                background
                    .overlay(showing("8"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("9")
            } label: {
                background
                    .overlay(showing("9"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var fourthRow: some View {
        HStack(spacing: 2) {
            Button {
                balanceAdjustment.append(".")
            } label: {
                background
                    .overlay(showing("."))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                balanceAdjustment.append("0")
            } label: {
                background
                    .overlay(showing("0"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                if !balanceAdjustment.isEmpty {
                    if balanceAdjustment.last == "." {
                        balanceAdjustment.removeLast()
                    }
                    balanceAdjustment.removeLast()
                }
            } label: {
                background
                    .overlay {
                        Image(systemName: "delete.left.fill")
                            .font(.largeTitle, weight: .bold)
                            .background(Color.white.opacity(0.2))
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var background: some View {
        Color.white
    }
    
    private func showing(_ string: String) -> some View {
        Text(string).font(.largeTitle, weight: .bold)
    }
}
