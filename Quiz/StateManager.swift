//
//  StateManager.swift
//  Quiz
//
//  Created by Nicko Lee on 3/24/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import Foundation

class StateManager {
    
    static var questionIndexKey = "QuestionIndexKey"
    static var numCorrectKey = "NumCorrectKey"
    
    // Remember static method means u don't need an object of the class to use these method can call it on the class itself
    static func saveState(numCorrect: Int, questionIndex: Int) {
        
        // Instantiate a UserDefaults object
        let defaults = UserDefaults.standard
        
        // Set some key value pairs to store in UserDefaults DB
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
    }
    
    static func retrieveValue(key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
    
    static func clearState() {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: questionIndexKey)
        defaults.removeObject(forKey: numCorrectKey)
    }
    
}
