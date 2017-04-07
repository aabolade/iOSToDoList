//
//  Task.swift
//  ToDoApp
//
//  Created by Leke Abolade on 07/04/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import RealmSwift

class Task: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var isCompleted = false
}
