//
//  File.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/14/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import Foundation
import SendGrid

public class EmailClient {
    
    
    func send(params : NSDictionary) -> Bool {
        // Send a basic example
        let personalization = Personalization(recipients: "uttamsingh@hotmail.com")
        let plainText = Content(contentType: ContentType.plainText, value: "Hello World")
        let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
        let email = Email(
            personalizations: [personalization],
            from: Address("uttamsingh@hotmail.com"),
            content: [plainText, htmlText],
            subject: "Testing Sendgrid"
        )
        do {
            try Session.shared.send(request: email)
            print("Sucessfully sent.")
        } catch {
            print(error)
        }

    }
}
