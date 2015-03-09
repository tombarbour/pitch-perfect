//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Tom Barbour on 07/03/2015.
//  Copyright (c) 2015 Tom Barbour. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    // Stores recorded audio file path and title
    var filePathURL: NSURL!
    var title: String!
    
    init (filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
    
}