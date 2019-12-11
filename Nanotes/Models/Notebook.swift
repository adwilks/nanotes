//
//  Notebook.swift
//  Nanotes
//
//  Created by Adrien Wilkins on 2019/12/11.
//  Copyright © 2019 Adrien Wilkins. All rights reserved.
//

import Foundation

// TODO: Need to load notes from CoreData Query into textfield
class notebook: ObservableObject {
    @Published var pages: [String]
    
    func addPage (_ newPageContents: String) {
        pages.append(newPageContents)
    }
    
    // We want to initialize the notebook so that the default entry into the notebook
    // (if the CoreData query returns null) is a blank entry
    
    init () {
        pages = [""]
    }
}
