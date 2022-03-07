//
//  SubscriptionDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-16.
//

import SwiftUI
import SwiftUIX

struct SubscriptionDetailsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 240, weight: .thin))
                    .padding(.vertical, 48)
                    .frame(maxWidth: UIScreen.main.bounds.width/2, maxHeight: UIScreen.main.bounds.height/2)
                Text("Subscription details")
                    .font(.title)
                    .fontWeight(.bold)
                Text(LocalizedStringKey("Using BarTab requires an active subscription. You can choose between paying monthly, annually or a one time fee that keeps you subscribed indefinitely.\n\nIf you choose to subscribe monthly or annually, your first subscription period will include a week long free trial before you are charged. If you decide you do not want to pay for the service, you need to cancel your subscription no less than 24 hours before the trial runs out, or you will be charged according to your chosen subscription type.\n\nSubscriptions are renewed automatically unless cancelled at least 24 hours before the end of the current subscription period. This can be done through Settings > Apple-ID > Subscriptions."))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 48)
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
