//
//  Section.swift
//  JPDesignCode
//
//  Created by aa on 2021/10/28.
//

import SwiftUI

struct Section: Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var logo: String
    var image: Image
    var color: Color
}

let sectionData = [
    Section(title: "Prototype designs in JP-SwiftUI",
            text: "18 Sections",
            logo: "Logo1",
            image: Image(uiImage: #imageLiteral(resourceName: "Card1")),
            color: Color(#colorLiteral(red: 0.4417540431, green: 0.3757942915, blue: 1, alpha: 1))),
    
    Section(title: "Build a JP-SwiftUI app",
            text: "20 Sections",
            logo: "Logo2",
            image: Image(uiImage: #imageLiteral(resourceName: "Card4")),
            color: Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))),
    
    Section(title: "JP-SwiftUI Advanced",
            text: "33 Sections",
            logo: "Logo3",
            image: Image(uiImage: #imageLiteral(resourceName: "Card2")),
            color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))),
]
