//
//  PostDetail.swift
//  iOSWidgetExplorer
//
//  Created by 200OK-IOS4 on 13/08/24.
//

import Foundation
import UIKit

class PostSummary: UIViewController {
    var postTitle: String?
    
    @IBOutlet weak var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = postTitle
    }

}
