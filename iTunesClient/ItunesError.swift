//
//  ItunesError.swift
//  iTunesClient
//
//  Created by Screencast on 4/12/17.
//  Copyright © 2017 Treehouse Island. All rights reserved.
//

import Foundation

enum ItunesError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingFailure(message: String)
}
