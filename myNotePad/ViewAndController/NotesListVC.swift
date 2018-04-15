//
//  NotesListVC.swift
//  myNotePad
//
//  Created by Mithun R on 14/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import UIKit

class NotesListVC: UIViewController {

    @IBOutlet weak var notesTblVw: UITableView!

    var selectedIndex:IndexPath?
    var initialDetailVC:UIViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialUISetup()

        getData()

        if self.splitViewController != nil {
            initialDetailVC = self.splitViewController?.viewControllers[1]
        }

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        if let index = selectedIndex {
            notesTblVw.deselectRow(at: index, animated: true)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "createNotesDetails") {
            let notesDetailVC = segue.destination as! NotesDetailsVC
            notesDetailVC.isViewMode = false
            notesDetailVC.listViewDelegate = self
        }
        else if (segue.identifier! == "showNotesDetails") {
            let notesDetailVC = segue.destination as! NotesDetailsVC
            notesDetailVC.isViewMode = true
            notesDetailVC.listViewDelegate = self
            notesDetailVC.currentData = DataManager.sharedInstance.notesList[(selectedIndex?.row)!]
        }

    }

    //MARK: Function / Methods:
    func loadInitialUISetup() {

        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        notesTblVw.estimatedRowHeight = 70
        notesTblVw.rowHeight = UITableViewAutomaticDimension
        notesTblVw.tableFooterView = UIView()
    }

    func getData() {

        DataManager.sharedInstance.getAllNotes { sucess in
            if sucess {
                notesTblVw.reloadData()
            }
        }

    }

    func loadInitialDetailView() {
        if let splitVC = self.splitViewController {
            var splitViewArray = splitVC.viewControllers

            splitViewArray[1] = initialDetailVC!
            self.splitViewController?.viewControllers = splitViewArray
        }
    }

    //MARK: Actions:
    @IBAction func newNotesAction(_ sender: Any) {

        if let index = selectedIndex {
            notesTblVw.deselectRow(at: index, animated: true)
        }

        performSegue(withIdentifier: "createNotesDetails", sender: self)
    }


}
//MARK: TableView Delegate and DataSource
extension NotesListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataManager.sharedInstance.notesList.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotesTableCell

        let currentNote = DataManager.sharedInstance.notesList[indexPath.row]

        cell.titleLbl.text = currentNote.nt_title
        cell.contentLbl.text = currentNote.nt_content
    
        return cell

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.sharedInstance.deleteNotesAtIndex(indexPath.row, completion: { (sucess) in
                if (sucess) {
                    getData()
                    loadInitialDetailView()
                }
            })


        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "showNotesDetails", sender: self)
        
    }

}

//MARK: Split Controller Delegate
extension NotesListVC: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        if primaryViewController .isKind(of: UINavigationController.self)
        {
            return true
        }
        else {
            return false
        }

    }
}

extension NotesListVC: NotesListProtocol {
    func reloadNotesList() {
        getData()
    }
}



