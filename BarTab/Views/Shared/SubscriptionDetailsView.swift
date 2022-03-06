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
                Text("Prenumerationsdetaljer")
                    .font(.title)
                    .fontWeight(.bold)
                Text("""
                    För att använda BarTab krävs en aktiv prenumeration. Alternativ för prenumerationer är betala månadsvis, betala årsvis eller betala en engångskostnad för en prenumeration som aldrig upphör.

                    Om du väljer att betala månadsvis eller årsvis inkluderas en veckas prövoperiod innan du debiteras. Du måste avbryta din prenumeration minst 24 timmar innan prövoperioden avslutas om du inte vill betala för tjänsten, annars debiteras du enligt vald prenumerationstid.
                    
                    Prenumerationer kommer automatiskt förnyas om inte automatisk förnyelse stängs av minst 24 timmar innan slutet på nuvarande prenumerationsperiod. Detta kan göras via Inställningar > Apple-ID > Abonnemang.
                    """)
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
