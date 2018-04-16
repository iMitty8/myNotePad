//
//  DataManager.swift
//  myNotePad
//
//  Created by Mithun R on 15/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {

    var appDelegate:AppDelegate
    var managedContext:NSManagedObjectContext


    var notesList:[Notes] = []


    static let sharedInstance = DataManager()
    private init() {

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext =
            appDelegate.persistentContainer.viewContext

    }

    func createNewNotes(id:String, title:String, content:String, completion: (Bool) ->()) {

        let entity =
            NSEntityDescription.entity(forEntityName: "Notes",
                                       in: managedContext)!

        let notes = Notes(entity: entity,
                          insertInto: managedContext)

        notes.nt_title = title
        notes.nt_ID = id
        notes.nt_content = content
        notes.nt_syncedStatus = false

        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("Could not save. \(error), \(error.userInfo)")
        }

    }

    func createNotesFromArray(notesArray:[Notes], completion:(Bool)->()) {


        deleteAllNotes { (success) in
            if success {

                for curretNotes in notesArray {

                    let entity =
                        NSEntityDescription.entity(forEntityName: "Notes",
                                                   in: managedContext)!
                    let notes = Notes(entity: entity,
                                      insertInto: managedContext)
                    notes.nt_ID = curretNotes.nt_ID
                    notes.nt_title = curretNotes.nt_title
                    notes.nt_content = curretNotes.nt_content
                    notes.nt_syncedStatus = true

                }

                do {
                    try managedContext.save()
                    completion(true)

                } catch let error as NSError {

                    print("Could not save. \(error), \(error.userInfo)")
                    completion(false)
                }


            }
        }

    }

    func getAllNotes(completion: (Bool) -> ()) {

        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()

        do {
            notesList = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }

    func getUnSyncedNotes(completion:(Bool, [Notes]) ->()) {

        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nt_syncedStatus == %@", false as NSNumber)


        do
        {
            let retrivedData = try managedContext.fetch(fetchRequest)
            if retrivedData.count > 0
            {
                let receivedArray = retrivedData

                do{
                    try managedContext.save()
                    completion(true, receivedArray)
                }
                catch
                {
                    completion(false, [])
                    print(error)
                }
            }
            else {
                completion(true, [])
            }
        }
        catch
        {
            completion(false, [])
            print(error)
        }


    }

    func updateDataForID(_ id:String, title:String, content:String, completion: (Bool) ->()) {

        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
        let predicate = NSPredicate(format: "nt_ID = '\(id)'")
        fetchRequest.predicate = predicate


        do
        {
            let retrivedData = try managedContext.fetch(fetchRequest)
            if retrivedData.count == 1
            {
                let objectUpdate = retrivedData[0]
                objectUpdate.nt_title = title
                objectUpdate.nt_content = content
                objectUpdate.nt_syncedStatus = false

                do{
                    try managedContext.save()
                    completion(true)
                }
                catch
                {
                    completion(false)
                    print(error)
                }
            }
            else if retrivedData.count < 1 {
                self.createNewNotes(id: id, title: title, content: content, completion: { (success) in
                    if success {
                        completion(true)
                    }
                    else {
                        print ("Create Notes failed")
                    }
                })
            }
        }
        catch
        {
            completion(false)
            print(error)
        }



    }

    func deleteNotesAtIndex(_ index: Int, completion: (Bool) ->()) {

        managedContext.delete(notesList[index])
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("Could not save. \(error), \(error.userInfo)")
        }

    }

    func deleteAllNotes(completion: (Bool) -> ()) {

        let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

        do {
            try managedContext.execute(deleteRequest)
            completion(true)
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            completion(false)
        }

    }

}
