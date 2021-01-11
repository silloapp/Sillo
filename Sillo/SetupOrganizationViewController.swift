//
//  SetupOrganizationViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/10/21.
//

import UIKit

class SetupOrganizationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.backItem?.backBarButtonItem = .init(barButtonSystemItem: <#T##UIBarButtonItem.SystemItem#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
