//
//  NoteViewController.swift
//  idderezovskiyPW4
//
//  Created by Ilya Derezovskiy on 30.10.2021.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    var outputVC: ViewController = ViewController(nibName: nil, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                #selector(didTapSaveNote(button:)))
    }

    @objc func didTapSaveNote(button: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let description = textView.text ?? ""
        if !title.isEmpty {
            let newNote = Note(context: outputVC.context)
            newNote.title = title
            newNote.descriptionText = description
            newNote.creationDate = Date()
        }
        outputVC.saveChanges()
        self.navigationController?.popViewController(animated: true)
    }
}
