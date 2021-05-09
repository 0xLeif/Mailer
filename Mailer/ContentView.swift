//
//  ContentView.swift
//  Mailer
//
//  Created by Leif on 5/3/21.
//

import SwiftUI

import EmailCourier

struct ContentView: View {
    @State private var email = Email(recipients: "")
    
    @State private var recipients: String = ""
    @State private var ccRecipients: String = ""
    @State private var bccRecipients: String = ""
    @State private var sender: String = ""
    @State private var subject: String = ""
    @State private var message: String = ""
    @State private var isMessageBodyHTML: Bool = false
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Section(
                    header: VStack {
                        HStack {
                            Text("Recipients")
                            Spacer()
                        }
                        Color.blue.frame(height: 1, alignment: .center)
                    }
                ) {
                    TextField("Recipients", text: $recipients)
                    TextField("CC Recipients", text: $ccRecipients)
                    TextField("BCC Recipients", text: $bccRecipients)
                }
                
                Section(
                    header: VStack {
                        HStack {
                            Text("Sender")
                            Spacer()
                        }
                        Color.blue.frame(height: 1, alignment: .center)
                    }
                ) {
                    TextField("Sender", text: $sender)
                }
                
                Section(
                    header: VStack {
                        HStack {
                            Text("Message")
                            Spacer()
                        }
                        Color.blue.frame(height: 1, alignment: .center)
                    }
                ) {
                    TextField("Subject", text: $subject)
                    
                    TextEditor(text: $message)
                        .padding()
                        .border(Color.blue, width: 1)
                }
                
                Button("Review") {
                    email.recipients = recipients
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: ",")
                        .map(String.init)
                    
                    email.ccRecipients = ccRecipients
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: ",")
                        .map(String.init)
                    
                    email.bccRecipients = bccRecipients
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: ",")
                        .map(String.init)
                    
                    email.sender = sender
                    email.subject = subject
                    
                    email.message = message
                    
                    try? EmailController(
                        presentingViewController: UIApplication.shared.rootViewController!
                    )
                    .send(email: email)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
    
    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}

