//
//  DeliveryTimeVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class DeliveryTimeVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deliveryBackView: UIView!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var scheduleBackView: UIView!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var backView: UIView!
    
    //MARK: - PROPERTIES -
    
    let timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.minimumDate = Date()
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    let dateFormatter : DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        return formatter
    }()
    
    var currentSelectedDate = Date()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        backView.layer.cornerRadius = 20.0
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.selectOne()
        deliveryLbl.text = PisiffikStrings.delivery()
        scheduleLbl.text = PisiffikStrings.schedule()
        dateLbl.text = dateFormatter.string(from: currentSelectedDate)
        applyBtn.setTitle(PisiffikStrings.apply(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize16
        titleLbl.textColor = R.color.textBlackColor()
        deliveryLbl.font = Fonts.mediumFontsSize16
        scheduleLbl.font = Fonts.mediumFontsSize16
        applyBtn.titleLabel?.font = Fonts.mediumFontsSize16
        applyBtn.backgroundColor = R.color.darkBlueColor()
        applyBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        self.deliveryBtn.isSelected = true
        self.scheduleBtn.isSelected = false
        setDeliveryView()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @objc func didSelectDateAndTime(sender: UIDatePicker) {
        let dateTimeInStr = dateFormatter.string(from: sender.date)
        dateLbl.text = dateTimeInStr
        currentSelectedDate = dateFormatter.date(from: dateTimeInStr) ?? Date()
        timePicker.removeFromSuperview()
    }
    
    @IBAction func didTapApplyBtn(_ sender: UIButton){
        sender.showAnimation {
            Constants.printLogs("\(Utils.shared.getUTCFormate(date: self.currentSelectedDate))")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapSelectDateBtn(_ sender: UIButton){
        openDateAndTimePicker()
    }
    
    @IBAction func didTapChangeDeliveryTimeBtn(_ sender: UIButton){
        if sender.tag == 0{
            setDeliveryView()
        }else{
            setScheduleView()
        }
    }
    
}

//MARK: - EXTENSION FOR METHODS -

extension DeliveryTimeVC{
    
    fileprivate func openDateAndTimePicker()  {
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 160), width: self.view.frame.width, height: 60.0)
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(didSelectDateAndTime(sender:)), for: .valueChanged)
    }
    
    fileprivate func setDeliveryView(){
        self.deliveryBtn.isSelected = true
        self.scheduleBtn.isSelected = false
        self.deliveryBackView.backgroundColor = R.color.lightBlueColor()
        self.deliveryLbl.textColor = R.color.textWhiteColor()
        self.deliveryBackView.layer.borderWidth = 0
        self.scheduleBackView.backgroundColor = R.color.backgroundColor()
        self.scheduleLbl.textColor = R.color.textBlackColor()
        self.scheduleBackView.layer.borderWidth = 1
        self.dateStackView.isHidden = true
    }
    
    fileprivate func setScheduleView(){
        self.deliveryBtn.isSelected = false
        self.scheduleBtn.isSelected = true
        self.deliveryBackView.backgroundColor = R.color.backgroundColor()
        self.deliveryLbl.textColor = R.color.textBlackColor()
        self.deliveryBackView.layer.borderWidth = 1
        self.scheduleBackView.backgroundColor = R.color.lightBlueColor()
        self.scheduleLbl.textColor = R.color.textWhiteColor()
        self.scheduleBackView.layer.borderWidth = 0
        self.dateStackView.isHidden = false
    }
    
}
