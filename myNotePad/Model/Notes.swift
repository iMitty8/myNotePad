//
//  Notes.swift
//  myNotePad
//
//  Created by Mithun R on 15/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import UIKit

enum fileStatus {
    case k_Pending
    case k_Synced
}

class Notes_TMp: NSObject {

    var nt_ID: String
    var nt_title: String
    var nt_content: String
    var nt_Status: fileStatus


    init(identifier:String, title:String, content:String, status:fileStatus) {

        self.nt_ID = identifier
        self.nt_title = title
        self.nt_content = content
        self.nt_Status = status


    }

}
