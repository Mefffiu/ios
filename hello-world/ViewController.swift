//
//  ViewController.swift
//  hello-world
//
//  Created by Guest User on 06.12.2019.
//  Copyright © 2019 Guest User. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AF.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }


}

