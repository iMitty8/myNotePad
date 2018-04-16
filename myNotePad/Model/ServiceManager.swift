//
//  ServiceManager.swift
//  myNotePad
//
//  Created by Mithun R on 16/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ServiceManager {


    static let sharedInstance = ServiceManager()
    private init() {

        //appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    func getAllNotes(completion: @escaping (_ success:Bool, _ resultArray:[Notes]?, _ error:Error?) -> Void) {

        Alamofire.request("http://localhost:5969/Notes/allNotes/").responseJSON { (responseData) -> Void in

            //print(responseData.request!)
            //print(responseData.response!)
            //print(responseData.error!)
            //print(responseData.value!)

            if((responseData.result.value) != nil && (responseData.error) == nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)

                var receivedArray:[[String:AnyObject]] = []
                if let resData = swiftyJsonVar["notes"].arrayObject {
                    receivedArray = resData as! [[String:AnyObject]]
                }

                var notesArray: [Notes] = []
                if receivedArray.count > 0 {

                    for currenData in receivedArray {

                        let NotesObj = Notes()

                        if let notesID = currenData["notesID"] as? String, let notesTitle = currenData["notesTitle"] as? String, let notesContent = currenData["notesContent"] as? String {

                            NotesObj.nt_ID = notesID
                            NotesObj.nt_title = notesTitle
                            NotesObj.nt_content = notesContent
                            NotesObj.nt_syncedStatus = true

                            notesArray.append(NotesObj)

                        }
                        else {
                            print("received an invalid data")
                        }
                    }
                }

                completion(true, notesArray, responseData.error)
            }
            else {
                completion(false, [], responseData.error)
            }
        }
    }

    func postUnsyncedListToServer(notes:[Notes], completion: @escaping (_ success:Bool, _ error:Error?) -> Void) {

        var parameterArray = [[String:Any]]()

        for currentNote in notes {

            var contentDict = [String:Any]()
            contentDict["notesID"] = currentNote.nt_ID
            contentDict["notesTitle"] = currentNote.nt_title
            contentDict["notesContent"] = currentNote.nt_content

            parameterArray.append(contentDict)
        }

        let urlString = "http://localhost:5969/Notes/updateNotes/"

        Alamofire.request(urlString, method: .post, parameters: ["notes": parameterArray],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                completion(true, response.error)
                break
            case .failure(let error):
                completion(false, response.error)
                print(error)
            }
        }

    }

    func deleteNotes(note:Notes, completion: @escaping (_ success:Bool, _ error:Error?) -> Void) {


        var contentDict = [String:Any]()
        contentDict["notesID"] = note.nt_ID

        let urlString = "http://localhost:5969/Notes/DeleteNotes/"

        Alamofire.request(urlString, method: .post, parameters: contentDict,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                completion(true, response.error)
                print(response)
                break
            case .failure(let error):
                completion(false, response.error)
                print(error)
            }
        }
    }

}
