//
//  AnonymousAssignment.swift
//  Sillo
//
//  Created by William Loo on 3/21/21.
//

import Foundation

let generator = AnonymousGenerator()
class AnonymousGenerator {

    //MARK: randomly pick and return poster alias
    func generatePosterAlias() -> String {
        let options: [String] = ["Beets", "Cabbage", "Watermelon", "Bananas", "Oranges", "Apple Pie", "Bongo", "Sink", "Boop"]
        return options.randomElement()!
    }

    //MARK: randomly pick and return a anonymous avatar
    func generatePosterImageName() -> String {
        let options: [String] = ["1","2","3","4"]
        return "avatar-\(options.randomElement()!)"
        
    }
}
