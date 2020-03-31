//
//  ViewController.swift
//  Quiz
//
//  Created by Nicko Lee on 3/19/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate, ResultViewControllerProtocol {
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    var model = QuizModel()
    var questions = [Question]()
    var questionIndex = 0 // keeps track of what question the user is currently viewing and answering
    var numCorrect = 0
    
    var resultVC: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // We want to later display the modal popup message. To do this we first need to create an instance of the result VC. We will instantiate the one we aleady customised in the storyboard
        resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController // This returns an instance of the VC from the storyboard but it doesn't know what type of VC it is so we need to cast it to the type we want. Note resultVC may or may not be nil depending on a couple of things. If storyboard is nil none of this will run. And if it can't cast it as a Result VC then the resultVC var will also be nil
        
        resultVC?.delegate = self
        resultVC?.modalPresentationStyle = .overCurrentContext
        
        // Conform to the table view protocols
        tableView.dataSource = self
        tableView.delegate = self
        
        // Kick off the process to retrive the questions. Notice that nothing gets returned from calling this. We will need to go back to QuizModel to create a custom protocol so we can contact the VC from the QuizModel and notify VC that the questions are ready
        // How does the QuizModel contact the VC when the questions are ready? When the VC creates an instance of the QM, we will have the VC set itself to the delegate property of the QM class. So that now the QM object has a reference to the VC
        model.delegate = self // self refers to the VC of course
        model.getQuestions()
    }
    
    func displayQuestion() {
        
        // Check the current question index is not beyond the bounds of the question array (otherwise we will get a crash)
        guard questionIndex < questions.count else {
            print("Trying to display a question index that is out of bounds")
            return
        }
        
        // If it is within the bounds then display the question
        questionLabel.text = questions[questionIndex].question!
        
        // Display the answers - simply need to tell the table view to reload the data
        tableView.reloadData() // just like what I used in Match App to reload my cards in the collection view. This triggers the table view to ask the VC for data again (i.e. those 2 protocol method calls. Ask for how many rows there are and for each row it is trying to display what cell should it use?)
        
        // Animate in the question
        slideInQuestion()
    }
    
    // MARK: Animation methods
    
    func slideInQuestion() {
        // Set the starting state
        rootStackView.alpha = 0
        stackViewLeadingConstraint.constant = 1000
        stackViewTrailingConstraint.constant = -1000
        view.layoutIfNeeded() // so that autolayout will update the layout right away. Thiis view is the view of the VC
        
        // Animate to the ending state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.rootStackView.alpha = 1
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func slideOutQuestion() {
        // Set the starting state
        rootStackView.alpha = 1
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        view.layoutIfNeeded()
        
        // Animate to the ending state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            
            self.rootStackView.alpha = 0
            self.stackViewLeadingConstraint.constant = -1000
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }

    // MARK: QuizProtocol method
    
    func questionsRetrieved(questions: [Question]) {
        
        // Set our question prop with questions from quiz model
        self.questions = questions
        
        // Check if there is a stored state
        let qIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        // Check if it's nil. If not, check if it's a valid index (i.e. within the count of [Questions])
        if qIndex != nil && qIndex! < questions.count {
            
            // Set the current index to the restored index
            questionIndex = qIndex!
            
            // Restore the num correct
            numCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as! Int
        }
        
        // Display the first question
        displayQuestion()
        
    }
    
    // MARK: TableView Protocol methods
    
    // TableView asks VC how many rows of data must we display?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Guard statement cos the table view needs an integer or it will crash. Here we are handling that
        guard questions.count > 0 && questions[questionIndex].answers != nil else {
            return 0
        }
        return questions[questionIndex].answers!.count
    }
    
    // This is the table view asking the VC for a particular row number, what is the table cell I need to use? And what sort of data should I display for that row?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Get a reference to the label in that cell
        let label = cell.viewWithTag(1) as! UILabel
        
        // TODO: Set the text for the label
        label.text = questions[questionIndex].answers![indexPath.row]
        
        return cell
    }
    
    // This is triggered when the user selects an answer    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check against question index being out of bounds
        guard questionIndex < questions.count else {
            return
        }
        
        print("user tapped me at \(indexPath)")
        
        // Declare vars to configure the popup
        var title: String = ""
        let message: String = questions[questionIndex].feedback!
        let action: String = "Next"
        
        // User has selected an answer
        if questions[questionIndex].correctAnswerIndex! == indexPath.row {
            // User has selected correct answer
            numCorrect += 1
            
            // Set the title for the popup
            title = "Correct!"
        } else {
            // User has selected the wrong answer
            
            // Set the title for the popup
            title = "Wrong!"
        }
        
        // Slide out question
        slideOutQuestion()
        
        // Display the popup
        // Before we can use resultVC we need to check it isn't nil. If not nil will display it over top of current VC
        if resultVC != nil {
            
            // let the main thread display the popup
            DispatchQueue.main.async {
                self.present(self.resultVC!, animated: true, completion: {
                    // Set the message for the popup:
                    self.resultVC!.setPopup(withTitle: title, withMessage: message, withAction: action)
                })
            }
        }
        
        
        // Increment questionIndex so we can jump to next question
        questionIndex += 1
        
        // Save state
        StateManager.saveState(numCorrect: numCorrect, questionIndex: questionIndex)
    }
    
    // MARK: ResultViewControllerProtocol methods
    
    func resultViewDismissed() {
        
        // Check the question index
        
        // If the question index == question count then we've finished the last question
        if questionIndex == questions.count {
            
            // Show summary
            if resultVC != nil {
                present(resultVC!, animated: true) {
                    self.resultVC?.setPopup(withTitle: "Summary", withMessage: "You got \(self.numCorrect) out of \(self.questions.count) correct.", withAction: "Restart")
                }
            }
            
            // Increment so the next time the user dismisses the dialog, we go into the next branch of this IF statement
            questionIndex += 1
            
            
            // Clear state
            StateManager.clearState()
        } else if questionIndex > questions.count {
            
            // Restart the quiz
            numCorrect = 0
            questionIndex = 0
            displayQuestion()
            
        } else {
            // Display the next question when the result view has been dismissed
            displayQuestion()
        }
    }
    

}

