//
//  EmailSender.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class EmailSender {
    
    static func sendFeedback(subject: String, message: String, returnAddress: String) {
        Firestore.firestore().collection("mail").addDocument(data: [
            "to": "forsell.johan@hotmail.com",
            "message": [
                "subject": subject,
                "text": "\(message)\n\nSent from \(returnAddress)",
            ],
        ])
    }
    
    static func sendEmails(to customers: [Customer], from user: User, with message: String, methods: [PaymentSelection]) async throws {
        var unsubscribed: [String] = []
        do {
            let unsubscribedCheck = try await Firestore.firestore().collection("unsubscribed").getDocuments()
            for document in unsubscribedCheck.documents {
                unsubscribed.append(document.data()["email"] as! String)
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        for customer in customers {
            
            let subjectText = String(format: NSLocalizedString("Current balance at %@", comment: ""), user.association ?? "BarTab")
            
            if !unsubscribed.contains(customer.email) && !customer.email.isEmpty && customer.email.contains("@") {
                
                Firestore.firestore().collection("mail").addDocument(data: [
                    "to" : customer.email,
                    "message" : [
                        "subject" : "\(subjectText)",
                        "html" : EmailSender.makeHtml(for: customer, from: user, with: message, methods: methods)
                    ]
                ])
            }
        }
    }
    
    static func makePaymentOptionComponents(for methods: [PaymentSelection]) -> String {
        var htmlString = ""
        for method in methods where method.active == true {
            htmlString += "<p style=\"margin:0 0 14px 0;\">\(method.localizedString): \(method.info)</p>"
        }
        return htmlString
    }
    
    static func makeHtml(for customer: Customer, from user: User, with message: String, methods: [PaymentSelection]) -> String {
        let customerName = customer.name
        let firstName = customerName.components(separatedBy: " ").first
        let color = customer.balance > 0 ? "7CD338" : "F05F55"
        let phoneNumber = user.number ?? ""
        let headerText = String(format: NSLocalizedString("Balance update", comment: ""))
        let bodyText = message
        let greeting = String(format: NSLocalizedString("Hello %@!", comment: ""), firstName ?? "")
        let currentBalanceText = String(format: NSLocalizedString("Your current balance at %@ is:", comment: ""), user.association ?? "BarTab")
        let missingEmail = String(format: NSLocalizedString("Email address missing", comment: ""))
        let questionsText = String(format: NSLocalizedString("Inqueries can be sent to:", comment: ""))
        let unsubscribeLinkText = String(format: NSLocalizedString("Unsubscribe", comment: ""))
        let unsubscribeMessageText = String(format: NSLocalizedString(" from future balance updates", comment: ""))
        let paymentOptions = EmailSender.makePaymentOptionComponents(for: methods)

        return
            """
            <!DOCTYPE html>
            <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office">
            <head>
                <meta charset="utf-8">
              <meta name="viewport" content="width=device-width,initial-scale=1">
              <meta name="x-apple-disable-message-reformatting">
              <title></title>
                <!--[if mso]>
              <style>
                table {border-collapse:collapse;border-spacing:0;border:none;margin:0;}
                div, td {padding:0;}
                div {margin:0 !important;}
                </style>
              <noscript>
                <xml>
                  <o:OfficeDocumentSettings>
                    <o:PixelsPerInch>96</o:PixelsPerInch>
                  </o:OfficeDocumentSettings>
                </xml>
              </noscript>
              <![endif]-->
              <style>
                table, td, div, h1, p {
                  font-family: Arial, sans-serif;
                }
                @media screen and (max-width: 530px) {
                  .email {
                    display: block;
                    padding: 8px;
                    margin-top: 14px;
                    border-radius: 6px;
                    background-color: #555555;
                    text-decoration: none !important;
                    font-weight: bold;
                  }
                  .col-lge {
                    max-width: 100% !important;
                  }
                }
                @media screen and (min-width: 531px) {
                  .col-sml {
                    max-width: 27% !important;
                  }
                  .col-lge {
                    max-width: 73% !important;
                  }
                }
              </style>
            </head>
            <body style="margin:0;padding:0;word-spacing:normal;background-color:#D3DEF7;">
              <div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#D3DEF7;">
                <table role="presentation" style="width:100%;border:none;border-spacing:0;">
                  <tr>
                    <td align="center" style="padding:0;">
                      <!--[if mso]>
                      <table role="presentation" align="center" style="width:600px;">
                      <tr>
                      <td>
                      <![endif]-->
                      <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                        <tr>
                          <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                            <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://firebasestorage.googleapis.com/v0/b/bartab-d48b2.appspot.com/o/applogo.png?alt=media&token=db7c44d2-975c-4640-a8e0-6dd9eb9a05f3" width="165" alt="BarTab Logo" style="width:120px;max-width:80%;height:auto;border:none;text-decoration:none;color:#ffffff;border-radius: 10px;"></a>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:30px;background-color:#ffffff;">
                            <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;text-align: center;">\(headerText)</h1>
                            <p style="margin:0;">\(bodyText)</p>
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
                            <!--[if mso]>
                            <table role="presentation" width="100%">
                            <tr>
                            <td style="width:145px;" align="left" valign="top">
                            <![endif]-->
                            <div class="col-sml" style="display:inline-block;width:100%;max-width:145px;vertical-align:top;text-align:left;font-family:Arial,sans-serif;font-size:14px;color:#363636;">
                              <img src="https://firebasestorage.googleapis.com/v0/b/bartab-d48b2.appspot.com/o/user.png?alt=media&token=62977152-825e-4d7e-900d-4db0ea8ce089" width="115" alt="Profile picture" style="width:115px;max-width:80%;margin-bottom:20px;">
                            </div>
                            <!--[if mso]>
                            </td>
                            <td style="width:395px;padding-bottom:20px;" valign="top">
                            <![endif]-->
                            <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                              <p style="margin-top:0;margin-bottom:12px;">\(greeting)</p>
                              <p style="margin-top:0;margin-bottom:18px;">\(currentBalanceText)</p>
                              <p style="margin:0;background: #14213D; text-decoration: none; padding: 10px 25px; color: #\(color); border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#cccccc"><!--[if mso]><i style="letter-spacing: 25px;mso-font-width:-100%;mso-text-raise:20pt">&nbsp;</i><![endif]--><span style="mso-text-raise:10pt;font-weight:bold;">\(Currency.display(customer.balance, with: user))</span><!--[if mso]><i style="letter-spacing: 25px;mso-font-width:-100%">&nbsp;</i><![endif]--></a></p>
                              <a href="https://bartab.info/history/\(customer.id ?? "")"><img src="https://firebasestorage.googleapis.com/v0/b/bartab-d48b2.appspot.com/o/history.png?alt=media&token=3f925ded-71ff-453b-a478-7822e20cbcc7" style="display: inline-block; width: 30px; height: auto; line-height: 50px; vertical-align: -8px; padding-left: 10px;"></a>
                            </div>
                            <!--[if mso]>
                            </td>
                            </tr>
                            </table>
                            <![endif]-->
                          </td>
                        </tr>
                        <tr>
                          <td style="padding:30px;text-align:center;font-size:20px;background-color:#14213D;color:#cccccc;">
                            \(paymentOptions)
                            <p style="margin:0;font-size:14px;line-height:20px;">\(questionsText)<br><a class="email" href="mailto:\(user.email ?? "")" style="color:#cccccc;text-decoration:underline;">&#128233; \(user.email ?? "\(missingEmail)")</a></p>
                            <p style="margin-top:20px;font-size:8px;line-height:20px;"><a style="color:#cccccc;" href="https://bartab.info/unsubscribe/\(customer.id ?? "")">\(unsubscribeLinkText)</a>\(unsubscribeMessageText)</p>
                          </td>
                        </tr>
                      </table>
                      <!--[if mso]>
                      </td>
                      </tr>
                      </table>
                      <![endif]-->
                    </td>
                  </tr>
                </table>
              </div>
            </body>
            </html>
            """
    }
}
