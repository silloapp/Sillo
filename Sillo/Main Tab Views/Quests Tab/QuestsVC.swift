//
//  SelectDateVC.swift
//  WithoutStoryboard
//
//  Created by USER on 17/02/21.
//

import UIKit

class SelectDateVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    

    //MARK :IBDeclarations:

    let TopTable = UITableView()
    var imgCalendar = UIImageView()
    var dateLabel = UILabel()
    var startButton = UIButton()
    var updatedPopup = UIView()
    var valueSelectedIndex = -1
    var valueSelected = String()
    let datePicker: UIDatePicker = UIDatePicker()
    var pickerBgView = UIView()
    
var selectedDate = String()
    
    var dateArr = ["Starts February 1,2021","Starts February 2,2021","Starts February 3,2021","Starts February 4,2021","Starts February 5,2021","Starts February 6,2021","Starts February 7,2021","Starts February 8,2021","Starts February 9,2021","Starts February 10,2021","Starts February 11,2021","Starts February 12,2021"]

    @objc let pickerView = UIPickerView()
    let doneButton = UIButton()
    
    var StartDateBool = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

        self.view.backgroundColor = ViewBgColor
        setNavBar()
       
    }
    
    func setNavBar()
    {
        
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        self.title = "A Title Here"

  //Setting Buttons :
        
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        self.navigationItem.leftBarButtonItems = [barbackbutton]
        
        let Imagebutton = UIButton(type: UIButton.ButtonType.custom)
        Imagebutton.setImage(UIImage(named: "Nathan"), for: .normal)
        Imagebutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Imagebutton.imageView?.contentMode = .scaleAspectFill
        Imagebutton.imageView?.borderWidth = 2
        Imagebutton.imageView?.borderColor = UIColor.init(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
        Imagebutton.imageView?.clipsToBounds = true
        Imagebutton.imageView?.layer.cornerRadius = 12
        
        let barImagebutton = UIBarButtonItem(customView: Imagebutton)
        self.navigationItem.rightBarButtonItems = [barImagebutton]
        
     
    }
    //==============================   *** BUTTON ACTIONS ***  ===============================//
    
    @objc func doneButtonButtonMethod() {
     
        self.dateLabel.isHidden = false
        self.imgCalendar.isHidden = false
        self.pickerBgView.isHidden = true

        
        if StartDateBool == true
        {
            if self.selectedDate != ""
            {
            
        self.dateLabel.text = "Starts \(self.selectedDate)"
       self.dateLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        self.dateLabel.textColor = .darkText
            
           self.pickerView.isHidden = true
           self.doneButton.isHidden = true
            self.datePicker.isHidden = true
                
                

            UIView.transition(with: self.updatedPopup,
                                     duration: 0.5,
                                     options: [.transitionCrossDissolve],
                                     animations: {
                                       
                                        self.updatedPopup.isHidden = false
                   },
                    completion: nil)
            
            var timer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(ResignPopup)), userInfo: nil, repeats: false)
            }
            else
            {
                self.pickerView.isHidden = true
                self.doneButton.isHidden = true
                 self.datePicker.isHidden = true
            }
            
           
        }
        else
        {
            
            
            let indexPath = [IndexPath(row: valueSelectedIndex, section: 0)]
            self.TopTable.reloadRows(at: indexPath, with: .none)
            
           self.pickerView.isHidden = true
           self.doneButton.isHidden = true
            
            
            UIView.transition(with: self.updatedPopup,
                                     duration: 0.5,
                                     options: [.transitionCrossDissolve],
                                     animations: {
                                       
                                        self.updatedPopup.isHidden = false
                   },
                    completion: nil)
            
            var timer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(ResignPopup)), userInfo: nil, repeats: false)
            
      
       
     }
    }
   
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
     }
    @objc func menuMethod() {
        
     }
    @objc func startButtonMethod() {
        
//        if dateLabel.text == "Start Date"
//        {
        self.pickerBgView.isHidden = false

        self.updatedPopup.isHidden = true
            StartDateBool = true
        self.dateLabel.isHidden = true
        self.imgCalendar.isHidden = true

        
            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(6, inComponent: 0, animated: false)
            self.pickerView.isHidden = true
            self.doneButton.isHidden = false
            
        self.datePicker.isHidden = false
        
        let doneButtonconstraints = [
            doneButton.rightAnchor.constraint(equalTo:   self.pickerView.rightAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -400)
            
            ]
        
        NSLayoutConstraint.activate(doneButtonconstraints)
    self.view.layoutIfNeeded()
       
        
     }
    
    @objc func ResignPopup(){

        UIView.transition(with: self.updatedPopup,
                                 duration: 0.5,
                                 options: [.transitionCurlUp],
                                 animations: {
                                   
                                   self.updatedPopup.isHidden = true
              
               },
                                 completion: nil)

    }
    
    //=============================*** SETTING CONSTRAINTS ***===============================//

    func setConstraints()
    
    {
//------------------------------------ FOR TABLE VIEW--------------------------------------------------//
                
        // FOR TOP TABLE  :

            TopTable.separatorStyle = .none
            TopTable.backgroundColor = .clear
                TopTable.bounces = true

        self.TopTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
            let TopTableconstraints = [
                TopTable.topAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
                TopTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
                TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
                TopTable.heightAnchor.constraint(equalToConstant: 200)
            ]
        

        self.view.addSubview(TopTable)
        self.TopTable.delegate = self
      self.TopTable.dataSource = self
        
   // for start date image & label:
        
        self.view.addSubview(imgCalendar)
        imgCalendar.image = UIImage.init(named: "calendar")
        
       let imgCalendarconstraints = [
        imgCalendar.topAnchor.constraint(equalTo:  self.TopTable.topAnchor, constant: 220),
        imgCalendar.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: 20),
            imgCalendar.widthAnchor.constraint(equalToConstant: 30),
            imgCalendar.heightAnchor.constraint(equalToConstant: 30)
               ]
        self.view.addSubview(imgCalendar)
        
        self.view.addSubview(dateLabel)
        dateLabel.text = "Start Date"
        dateLabel.textColor = themeColor
        dateLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        
       let dateLabelconstraints = [
        dateLabel.topAnchor.constraint(equalTo:  self.TopTable.topAnchor, constant: 220),
        dateLabel.leftAnchor.constraint(equalTo:  self.imgCalendar.leftAnchor, constant: 40),
        dateLabel.heightAnchor.constraint(equalToConstant: 30),
        dateLabel.rightAnchor.constraint(equalTo:  self.view.rightAnchor, constant: -20),

               ]
        
// FOR PICKER VIEW  :
        
        
        
    pickerBgView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)

        let pickerBgViewconstraints = [
            pickerBgView.bottomAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            pickerBgView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            pickerBgView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
                //pickerView.topAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: 150)
            pickerBgView.heightAnchor.constraint(equalToConstant: 400)
            ]

        self.view.addSubview(pickerBgView)
        pickerBgView.isHidden = true
        

        pickerView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)

        let pickerViewconstraints = [
                pickerView.bottomAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                pickerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
                pickerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
                //pickerView.topAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: 150)
                pickerView.heightAnchor.constraint(equalToConstant: 350)
            ]

        self.pickerBgView.addSubview(pickerView)
        self.pickerView.delegate = self
      self.pickerView.dataSource = self
        
        self.pickerBgView.addTopShadow(shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, offset: CGSize(width: 0.0, height : -5.0))
        
        self.pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.red
        self.pickerView.selectRow(15, inComponent: 0, animated: false)
        
     
        self.pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.red
        
        self.pickerView.isHidden = true
        pickerView.showsSelectionIndicator = false

 // for done button:
        
        doneButton.backgroundColor = .clear
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.darkGray, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 16)

//        let doneButtonconstraints = [
//            doneButton.rightAnchor.constraint(equalTo:   self.pickerView.rightAnchor, constant: 0),
//            doneButton.widthAnchor.constraint(equalToConstant: 70),
//            doneButton.heightAnchor.constraint(equalToConstant: 30),
//            doneButton.topAnchor.constraint(equalTo:  self.pickerView.topAnchor, constant: 0)
//            ]
        
        let doneButtonconstraints = [
            doneButton.rightAnchor.constraint(equalTo:   self.pickerView.rightAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor, constant: -400)
            ]

        self.view.addSubview(doneButton)
       doneButton.addTarget(self, action:#selector(doneButtonButtonMethod), for: .touchUpInside)
        doneButton.isHidden = true
        
// for StartButton:
        
        startButton.backgroundColor = .clear

        let startButtonconstraints = [
            startButton.rightAnchor.constraint(equalTo:   self.dateLabel.rightAnchor, constant: 0),
            startButton.leftAnchor.constraint(equalTo: self.imgCalendar.leftAnchor, constant: 0),
            startButton.heightAnchor.constraint(equalToConstant: 30),
            startButton.topAnchor.constraint(equalTo:  self.TopTable.topAnchor, constant: 220)
            ]

        self.view.addSubview(startButton)
        self.startButton.addTarget(self, action:#selector(startButtonMethod), for: .touchUpInside)

  // for Update Popup :
                
          updatedPopup.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)

          let updatedPopupnconstraints = [
            updatedPopup.centerXAnchor.constraint(equalTo:self.view.centerXAnchor, constant: 0),
            updatedPopup.widthAnchor.constraint(equalToConstant: 150),
            updatedPopup.heightAnchor.constraint(equalToConstant: 40),
            updatedPopup.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
             ]

         self.view.addSubview(updatedPopup)
        updatedPopup.clipsToBounds = true
        updatedPopup.layer.cornerRadius = 20
        self.updatedPopup.isHidden = true

        
        let updatedLbl = UILabel()
        self.updatedPopup.addSubview(updatedLbl)
        updatedLbl.text = "Updated"
        updatedLbl.textColor = themeColor
        updatedLbl.font = UIFont(name: "Apercu-Regular", size: 17)
        
       let updatedLblconstraints = [
        updatedLbl.centerXAnchor.constraint(equalTo:self.updatedPopup.centerXAnchor, constant: -10),
        updatedLbl.heightAnchor.constraint(equalToConstant: 30),
        updatedLbl.centerYAnchor.constraint(equalTo:self.updatedPopup.centerYAnchor, constant: 0)
               ]
        
        
        let checkImg = UIImageView()
        self.updatedPopup.addSubview(checkImg)
        checkImg.image = UIImage.init(named: "check")
        
       let checkImgconstraints = [
        checkImg.centerXAnchor.constraint(equalTo:self.updatedPopup.centerXAnchor, constant: 35),
        checkImg.heightAnchor.constraint(equalToConstant: 15),
        checkImg.widthAnchor.constraint(equalToConstant: 15),
        checkImg.centerYAnchor.constraint(equalTo:self.updatedPopup.centerYAnchor, constant: 0)
               ]

        
  //      for date picker:
        datePicker.timeZone = .none
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(SelectDateVC.datePickerValueChanged(_:)), for: .valueChanged)
        
        let datePickerconstraints = [
            datePicker.bottomAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            datePicker.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            datePicker.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
       //  datePicker.topAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: 50)
            datePicker.heightAnchor.constraint(equalToConstant: 350 )
            
            ]
        
        self.datePicker.isHidden = true
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
             }
             else
             {
                  }
        datePicker.datePickerMode = .date


        // Add DataPicker to the view
        self.pickerBgView.addSubview(datePicker)
        
        NSLayoutConstraint.activate(pickerBgViewconstraints)
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(imgCalendarconstraints)
        NSLayoutConstraint.activate(dateLabelconstraints)
        NSLayoutConstraint.activate(pickerViewconstraints)
        NSLayoutConstraint.activate(startButtonconstraints)
        NSLayoutConstraint.activate(updatedPopupnconstraints)
        NSLayoutConstraint.activate(updatedLblconstraints)
        NSLayoutConstraint.activate(checkImgconstraints)
        NSLayoutConstraint.activate(doneButtonconstraints)
        NSLayoutConstraint.activate(datePickerconstraints)

        self.pickerBgView.translatesAutoresizingMaskIntoConstraints = false
        self.TopTable.translatesAutoresizingMaskIntoConstraints = false
        self.imgCalendar.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.updatedPopup.translatesAutoresizingMaskIntoConstraints = false
        updatedLbl.translatesAutoresizingMaskIntoConstraints = false
        checkImg.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false


        self.view.layoutIfNeeded()
        // Set some of UIDatePicker properties
        
             
             
         }
         
         
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
             
             // Create date formatter
             let dateFormatter: DateFormatter = DateFormatter()
             
             // Set date format
             dateFormatter.dateFormat = "MMM dd,yyyy"
             
             // Apply date format
             let selectedDate: String = dateFormatter.string(from: sender.date)
            self.selectedDate = selectedDate
             print("Selected value \(selectedDate)")
         }
    
 //MARK : picker actions:
    
   
   
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//

    //MARK :  Table View Delegate Methods:
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
   let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
 
    cell.backgroundColor = .clear
        cell.selectionStyle = .none
    
    cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 15)
    cell.textLabel?.textColor = .darkGray
    cell.textLabel?.numberOfLines = 0
    
    
    cell.textLabel?.text = "lorem ispum lorem ispum lorem ispum lorem ispum lorem ispum lorem ispum lorem ispum lorem ispum"
 //   cell.imageView?.image = UIImage.init(named: "hash-key")
   cell.accessoryView = UIImageView(image:UIImage(named:"hash-key")!)
    cell.accessoryView?.isHidden = true
   // cell.accessoryType = .detailDisclosureButton
    
    let selectedDateButton = UIButton()
    selectedDateButton.backgroundColor = .clear
    cell.contentView.addSubview(selectedDateButton)
    selectedDateButton.titleLabel?.font = UIFont.init(name: "Apercu-Bold", size: 17)
    selectedDateButton.setTitleColor(themeColor, for: .normal)
    selectedDateButton.clipsToBounds = true
    selectedDateButton.layer.cornerRadius = 5
    selectedDateButton.borderWidth = 2
    selectedDateButton.borderColor = themeColor
    
   let selectedDateconstraints = [
    selectedDateButton.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor, constant: 12),
    selectedDateButton.rightAnchor.constraint(equalTo:  cell.contentView.layoutMarginsGuide.rightAnchor, constant: 40),
    selectedDateButton.heightAnchor.constraint(equalToConstant: 50),
    selectedDateButton.widthAnchor.constraint(equalToConstant: 50)
       ]
    
    NSLayoutConstraint.activate(selectedDateconstraints)
    selectedDateButton.translatesAutoresizingMaskIntoConstraints = false
    cell.contentView.layoutIfNeeded()
    if valueSelectedIndex == indexPath.row
    {
        selectedDateButton.setTitle(self.valueSelected, for: .normal)
    }
    else
    {
        //selectedDateButton.setTitle("#", for: .normal)
    }
     
    return cell
        
    }
    
   func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StartDateBool = false
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow(6, inComponent: 0, animated: false)
        self.pickerView.isHidden = false
        self.doneButton.isHidden = false
        self.pickerBgView.isHidden = false

        
        self.dateLabel.isHidden = true
        self.imgCalendar.isHidden = true
        
        let doneButtonconstraints = [
            doneButton.rightAnchor.constraint(equalTo:   self.pickerView.rightAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor, constant: -350)
            ]
        
        NSLayoutConstraint.activate(doneButtonconstraints)
        self.view.layoutIfNeeded()
        self.datePicker.isHidden = true
        valueSelectedIndex = indexPath.row
        
       
    }
    
 
    
    //MARK :  Picker View Delegate Methods:

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if StartDateBool == true
        {
            return dateArr.count
        }
        else
        {
            return 30
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if StartDateBool == true
        {
            return dateArr[row]
        }
        else
        {
            return "\(row+1)"
        }
        return "\(row+1)"

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if StartDateBool == true
        {
            self.valueSelected = ""
            self.valueSelected = dateArr[row]
         
        }
        else
        {
            self.valueSelected = ""
            self.valueSelected = "\(row+1)" as String
         
        }
      
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
