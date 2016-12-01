//
//  NoNavBarNavigationController.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 23.11.16.
//  Copyright © 2016 Dmitry Kuklin. All rights reserved.
//

import UIKit

class NoNavBarNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.clear
        navigationBarAppearace.barTintColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
