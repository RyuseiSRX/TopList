//
//  TypeSelectionViewController.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/13.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import UIKit

class TypeSelectionViewController: UIViewController {

    let viewModel: TypeSelectionViewModel

    init(viewModel: TypeSelectionViewModel) {
           self.viewModel = viewModel

           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Select types to view list"
    }

}
