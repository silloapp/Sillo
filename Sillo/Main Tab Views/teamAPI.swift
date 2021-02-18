//
//  ContactAPI.swift
//  contactsapp
//
//  Created by SoftAuthor on 2019-04-20.
//  Copyright © 2019 SoftAuthor. All rights reserved.
//

import Foundation

class teamAPI {
    static func getContacts() -> [Contact]{
        let contacts = [
            Contact(name: "My Profile", jobTitle: "Designer", country: "bo"),
            Contact(name: "My Connnections", jobTitle: "SEO Specialist", country: "be"),
            Contact(name: "People", jobTitle: "Interactive Designer", country: "af"),
            Contact(name: "Engagement", jobTitle: "Architect", country: "al"),
            Contact(name: "Notifications", jobTitle: "Economist", country: "br"),
            Contact(name: "Reports", jobTitle: "Web Strategist", country: "ar"),
            Contact(name: "Quests", jobTitle: "Product Designer", country: "az"),
            Contact(name: "Sign Out", jobTitle: "Editor", country: "bo")
        ]
        return contacts
    }
}
