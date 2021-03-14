// Copyright 2018, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// License   https://creativecommons.org/publicdomain/zero/1.0/
// Source    https://www.ralfebert.de/ios-examples/uikit/choicepopover/

import UIKit

@available(iOS 13.0, *)


class ArrayChoiceTableViewController<Element> : UITableViewController {
    
  
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    private let values : [Element]
    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    
    init(_ values : [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        
        super.init(style: .plain)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Dismissing), name: Notification.Name("dismissAction"), object: nil)
        
        
        
    }
    @objc func Dismissing()
     {
        self.dismiss()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = ""
        cell.textLabel?.text = labels(values[indexPath.row])
        cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 3)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byTruncatingTail
        
     /*   cell.detailTextLabel?.text = labels(values[indexPath.row])
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byTruncatingTail*/
        
       //    cell.detailTextLabel
        
        tableView.separatorStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        onSelect?(values[indexPath.row])
    }
    
    func dismiss()
    {
        self.dismiss(animated: true)
    }
    
    
}
