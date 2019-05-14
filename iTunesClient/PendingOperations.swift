//
//  PendingOperations.swift
//  iTunesClient
//
//  Created by Screencast on 4/12/17.
//  Copyright © 2017 Treehouse Island. All rights reserved.
//

import Foundation

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}
