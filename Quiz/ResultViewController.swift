//
//  ResultViewController.swift
//  Quiz
//
//  Created by Nicko Lee on 3/23/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func resultViewDismissed()
}

class ResultViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: ResultViewControllerProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set rounded corners for the dialog view
        dialogView.layer.cornerRadius = 10
    }
    
    func setPopup(withTitle: String, withMessage: String, withAction: String) {
        resultLabel.text = withTitle
        feedbackLabel.text = withMessage
        dismissButton.setTitle(withAction, for: .normal)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        // This is easy - can just call the VC's dismiss method - which will remove this VC from the V if it has been shown modally. You can do some animation from that built-in method
        dismiss(animated: true, completion: {
            // Clear the labels
            self.resultLabel.text = ""
            self.feedbackLabel.text = ""
        })
        delegate?.resultViewDismissed()
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
