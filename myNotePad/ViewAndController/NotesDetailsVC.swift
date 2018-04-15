//
//  NotesDetailsVC.swift
//  myNotePad
//
//  Created by Mithun R on 14/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import UIKit
import CoreData


protocol NotesListProtocol:class {

    func reloadNotesList()

}

class NotesDetailsVC: UIViewController {


    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var utilBtnRegular: UIButton!

    weak var listViewDelegate:NotesListProtocol!

    var utilButton: UIButton!
    var isViewMode: Bool!
    var currentData:Notes?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInitialUISetup()
        setDataToUI()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpdatedContentCount()
    }

    override func viewWillLayoutSubviews() {

        getUpdatedTextVwHeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Function / Methods:
    func loadInitialUISetup() {

        contentTextView.isScrollEnabled = false

        utilButton = UIButton(type: .system)
        utilButton.frame.size = CGSize(width: 40, height: 20)
        utilButton.setTitle("Edit", for: .normal)
        utilButton.addTarget(self, action: #selector(utilBtnAction), for: .touchUpInside)

        utilBtnRegular.setTitle("Edit", for: .normal)
        utilBtnRegular.addTarget(self, action: #selector(utilBtnAction), for: .touchUpInside)


        let rightBarButton = UIBarButtonItem(customView: utilButton)
        self.navigationItem.rightBarButtonItem = rightBarButton

        updateUIforViewMode()
    }

    func updateUIforViewMode() {

        if (isViewMode) {

            titleLbl.isUserInteractionEnabled = false
            contentTextView.isUserInteractionEnabled = false
            utilButton.setTitle("Edit", for: .normal)
            utilBtnRegular.setTitle("Edit", for: .normal)

            countLbl.isHidden = true
        }
        else {
            titleLbl.isUserInteractionEnabled = true
            contentTextView.isUserInteractionEnabled = true
            utilButton.setTitle("Save", for: .normal)
            utilBtnRegular.setTitle("Save", for: .normal)

            countLbl.isHidden = false

            enableOrDisableRightButton()
        }
    }

    func setDataToUI() {

        if let data = currentData {
            titleLbl.text = data.nt_title
            contentTextView.text = data.nt_content
        } else {
            titleLbl.text = ""
            contentTextView.text = ""
        }

    }

    func enableOrDisableRightButton() {

        if titleLbl.text?.count == 0 || contentTextView.text?.count == 0 {
            utilButton.isEnabled = false
            utilBtnRegular.isEnabled = false
        }
        else {
            utilButton.isEnabled = true
            utilBtnRegular.isEnabled = true
        }
    }

    func getUpdatedTextVwHeight() {

        //contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.sizeToFit()
        let calHeight = contentTextView.frame.size.height
        contentHeightConstraint.constant = calHeight < CGFloat(defaultTextFieldHeight) ? CGFloat(defaultTextFieldHeight) : calHeight

    }

    func setUpdatedContentCount() {

        let remainingCount = maxTextFieldCount - contentTextView.text.count
        countLbl.text = "\(remainingCount) remaining"

    }

    @objc func utilBtnAction() {

        if (isViewMode) {

            isViewMode = false
            updateUIforViewMode()
            contentTextView.becomeFirstResponder()
        }
        else {

            isViewMode = true
            updateUIforViewMode()

            titleLbl.resignFirstResponder()
            contentTextView.resignFirstResponder()

            if currentData != nil {
                updateData()
            } else {
                createNote()
            }

        }


    }

    func updateData() {


        let notesID = currentData?.nt_ID

        DataManager.sharedInstance.updateDataForID(notesID ?? "", title: titleLbl.text!, content: contentTextView.text) { (success) in
            if success {
                if self.navigationController == nil {
                    listViewDelegate.reloadNotesList()
                }
            }
        }
    }

    func createNote() {

        DataManager.sharedInstance.createNewNotes(id: "iOS\(Date.init())", title: titleLbl.text!, content: contentTextView.text) { success in
            if success {
                isViewMode = true
                updateUIforViewMode()

                if self.navigationController == nil {
                    listViewDelegate.reloadNotesList()
                }
            }
        }
    }


}

extension NotesDetailsVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        getUpdatedTextVwHeight()
        setUpdatedContentCount()

        enableOrDisableRightButton()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let updatedText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars =  updatedText.count
        return numberOfChars <= maxTextFieldCount;
    }

}

extension NotesDetailsVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "" && textField.text?.count == 1  || contentTextView.text?.count == 0 {
            utilButton.isEnabled = false
            utilBtnRegular.isEnabled = false
        } else {
            utilButton.isEnabled = true
            utilBtnRegular.isEnabled = true
        }

        return true
    }
}
