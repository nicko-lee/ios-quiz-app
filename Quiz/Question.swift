//
//  Question.swift
//  Quiz
//
//  Created by Nicko Lee on 3/19/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import Foundation

struct Question: Codable {
    
    var question: String?
    var answers: [String]?
    var correctAnswerIndex: Int?
    var feedback: String?
}
