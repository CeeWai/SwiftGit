/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct that represents the contents of a textual document with a body and title.
*/

import Foundation
import UIKit

struct Document: Codable {
    var docID: String?
    var title: String?
    var body: String?
    var docOwner: String?
    var docImages: [String]?
    
    internal init(
        docID: String?,
        title: String?,
        body: String?,
        docOwner: String?,
        docImages: [String]?
    ){
        self.docID = docID
        self.title = title
        self.body = body
        self.docOwner = docOwner
        self.docImages = docImages
    }
    
    mutating func setEmptyDocImages() {
        self.docImages = []
    }
    
}
