//
//  LongPressViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class LongPressViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    var projectItem : Project?
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var selectedpickervalue = ""
    var selectedpickerrow = 0
    var ongoingtask :[ProjectTask] = []
    @IBOutlet var popover: UIView!
    @IBOutlet var popover2: UIView!
    @IBOutlet var popover4: UIView!
    @IBOutlet var popover3: UIView!
    var popoverstatus = 1
    var popoverstatus2 = 1
    var popoverstatus3 = 1
    var popoverstatus4 = 1
    var taskid = 0
    @IBOutlet var calendarWeekView: LongPressWeekView!
    let viewModel = AllDayViewModel(projectid: 1)
    @IBOutlet weak var taskdayview2: UIView!
    @IBOutlet weak var taskhourview2: UIView!
    @IBOutlet weak var tasktitleview: UIView!
    @IBOutlet weak var taskdayview: UIView!
    @IBOutlet weak var taskhoursview: UIView!
    @IBOutlet weak var addevent: UIButton!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var hourlabel: UILabel!
    @IBOutlet weak var titlefield: UITextField!
    @IBOutlet weak var daylabel2: UILabel!
    @IBOutlet weak var hourlabel2: UILabel!
    var addeventbool = 0
    let days = [Int](1...100)
    let hours = [Int](1...24)
    var selecttask = ""
    var selectdays = 0
    var selecthours = 1
    var selecttaskid = 0
    var pickertype = 0;
    var deleteevent = "";
    //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissviewall(_:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        ongoingtask = ProjectTaskDataManager.loadtaskbyprojectid(id: (projectItem?.projectId!)!)
        addevent.layer.cornerRadius = 40
        addevent.layer.borderColor = UIColor.systemRed.cgColor
        addevent.layer.borderWidth = 2;
        addevent.layer.backgroundColor = UIColor.systemBackground.cgColor
        addevent.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        var projectevents : [AllDayEvent] = []
        var users = ProjectgroupDataManager.loadsubscribed(projectid: (projectItem?.projectId!)!)
        for user in users{
            var projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe1(userid: user.userid!)
                  var stringquery = ""
                  var lastremoved = ""
                  for item in projectgroupList{
                      stringquery = stringquery + String(item.projectid!) + ","
                  }
                  lastremoved = String(stringquery.dropLast())
                  print(lastremoved)
                  var itemlist = ProjectEventDataManager.loadProjecteventsbyprojectidin(projectid: lastremoved)
                  for item in itemlist{
                      if (item.projectid != (projectItem?.projectId!)!){
                        item.title = user.username!
                      }
                  }
            projectevents.append(contentsOf: itemlist)
        }
        //display event of every group member project and current project events
        viewModel.events = projectevents
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        setupBasic()
        setupCalendarView()
        //setupNaviBar()
        //code below is to display add existing/new/delete event  popover
        let gesture = UITapGestureRecognizer(target: self, action: #selector(titleaction))
        tasktitleview.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(dayaction))
        taskdayview.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(houraction))
        taskhoursview.addGestureRecognizer(gesture3)
        let gesture22 = UITapGestureRecognizer(target: self, action: #selector(dayaction2))
        taskdayview2.addGestureRecognizer(gesture22)
        let gesture33 = UITapGestureRecognizer(target: self, action: #selector(houraction2))
        taskhourview2.addGestureRecognizer(gesture33)
           let bottomline = CALayer()
             bottomline.frame = CGRect(x:0,y:tasktitleview.frame.height - 2, width: tasktitleview.frame.width,height: 0.5)
             bottomline.backgroundColor =         UIColor.gray.cgColor
             tasktitleview.layer.addSublayer(bottomline)
             let bottomline2 = CALayer()
             bottomline2.frame = CGRect(x:0,y:taskdayview.frame.height - 2, width: taskdayview.frame.width,height: 0.5)
             bottomline2.backgroundColor =         UIColor.gray.cgColor
             taskdayview.layer.addSublayer(bottomline2)
             let bottomline3 = CALayer()
             bottomline3.frame = CGRect(x:0,y:taskhoursview.frame.height - 2, width: taskhoursview.frame.width,height: 0.5)
             bottomline3.backgroundColor =         UIColor.gray.cgColor
             taskhoursview.layer.addSublayer(bottomline3)
                                  //  view.addGestureRecognizer(tap)
             let bottomline4 = CALayer()
             bottomline4.frame = CGRect(x:0,y:titlefield.frame.height - 2, width: titlefield.frame.width,height: 1)
             bottomline4.backgroundColor =         UIColor.systemRed.cgColor
             titlefield.borderStyle = .none
             titlefield.layer.addSublayer(bottomline4)
             titlefield.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
             let bottomline5 = CALayer()
             bottomline5.frame = CGRect(x:0,y:taskdayview2.frame.height - 2, width: taskdayview2.frame.width,height: 0.5)
             bottomline5.backgroundColor =         UIColor.gray.cgColor
             taskdayview2.layer.addSublayer(bottomline5)
             let bottomline6 = CALayer()
             bottomline6.frame = CGRect(x:0,y:taskhourview2.frame.height - 2, width: taskhourview2.frame.width,height: 0.5)
             bottomline6.backgroundColor =         UIColor.gray.cgColor
             taskhourview2.layer.addSublayer(bottomline6)
                              // view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
        ongoingtask = ProjectTaskDataManager.loadtaskbyprojectid(id: (projectItem?.projectId!)!)
               addevent.layer.cornerRadius = 40
               addevent.layer.borderColor = UIColor.systemRed.cgColor
               addevent.layer.borderWidth = 2;
               addevent.layer.backgroundColor = UIColor.systemBackground.cgColor
               addevent.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
               var projectevents : [AllDayEvent] = []
               var users = ProjectgroupDataManager.loadsubscribed(projectid: (projectItem?.projectId!)!)
               for user in users{
                   var projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe1(userid: user.userid!)
                         var stringquery = ""
                         var lastremoved = ""
                         for item in projectgroupList{
                             stringquery = stringquery + String(item.projectid!) + ","
                         }
                         lastremoved = String(stringquery.dropLast())
                         print(lastremoved)
                         var itemlist = ProjectEventDataManager.loadProjecteventsbyprojectidin(projectid: lastremoved)
                         for item in itemlist{
                             if (item.projectid != (projectItem?.projectId!)!){
                               item.title = user.username!
                             }
                         }
                   projectevents.append(contentsOf: itemlist)
               }
               viewModel.events = projectevents
               viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
               setupBasic()
               setupCalendarView()
        NotificationCenter.default.addObserver(self, selector: #selector(sendtolongpressview(_:)), name: Notification.Name(rawValue: "sendtolongpressview"), object: nil)
        // notifcation listener for delete onclick from longpressweekview
    }
    @objc func dismissviewall(_ sender:UITapGestureRecognizer) {
        if popover2.isDescendant(of: view){
            popover2.removeFromSuperview()
            
        }
    }
    @objc func sendtolongpressview(_ notification: Notification) {
        print("dsda")
        let data = notification.userInfo!["eventid"]!
       // view.addGestureRecognizer(tap)
        deleteevent = data as! String
          if popoverstatus2 == 1{
                             self.popover2.removeFromSuperview()
                             popoverstatus2 = 0
                         }
                         if popoverstatus2 == 0{
                             self.view.addSubview(popover2)
                             let superView = self.view.superview
                             superView!.addSubview(popover2)
                             popover2.translatesAutoresizingMaskIntoConstraints = false

                             NSLayoutConstraint.activate([

                                     // 5
                                     NSLayoutConstraint(item: popover2, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0),

                                     // 6
                                     NSLayoutConstraint(item: popover2, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0),

                                     // 7
                                     popover2.heightAnchor.constraint(equalToConstant:140),
                         
                                     //8
                                     popover2.widthAnchor.constraint(equalToConstant: 414)
                                 ])
                             popoverstatus2 = 1
              }
    }
    @IBAction func deletepressed(_ sender: Any) {
        ProjectEventDataManager.deletebyid(projecteventid: deleteevent)
        for (index,element) in viewModel.events.enumerated(){
            print(element.id)
            if element.id == deleteevent{
                viewModel.events.remove(at: index)
                viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
                customreload(calendarWeekView)
                popover2.removeFromSuperview()
            }
        }
        
    }
    func customreload(_ weekView: JZLongPressWeekView) {
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
        
    }
    //objc functions to display popover with gesture
    @objc func titleaction(sender:UITapGestureRecognizer){
         popover.removeFromSuperview()
         pickertype = 1
         picker = UIPickerView.init()
                         picker.delegate = self
                         picker.dataSource = self
                         picker.backgroundColor = UIColor.white
                         picker.setValue(UIColor.black, forKey: "textColor")
                         picker.autoresizingMask = .flexibleWidth
                         picker.contentMode = .center
                         picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                         self.view.addSubview(picker)

                         toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size	.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                         toolBar.barStyle = .blackTranslucent
                         toolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped))]
                         self.view.addSubview(toolBar)
    }
    @objc func dayaction(sender:UITapGestureRecognizer){
        popover.removeFromSuperview()
        pickertype = 2
        picker = UIPickerView.init()
                        picker.delegate = self
                        picker.dataSource = self
                        picker.backgroundColor = UIColor.white
                        picker.setValue(UIColor.black, forKey: "textColor")
                        picker.autoresizingMask = .flexibleWidth
                        picker.contentMode = .center
                        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                        self.view.addSubview(picker)

                        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size    .height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                        toolBar.barStyle = .blackTranslucent
                        toolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped2))]
                        self.view.addSubview(toolBar)
    }
    @objc func houraction(sender:UITapGestureRecognizer){
        popover.removeFromSuperview()
        pickertype = 3
        picker = UIPickerView.init()
                        picker.delegate = self
                        picker.dataSource = self
                        picker.backgroundColor = UIColor.white
                        picker.setValue(UIColor.black, forKey: "textColor")
                        picker.autoresizingMask = .flexibleWidth
                        picker.contentMode = .center
                        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                        self.view.addSubview(picker)

                        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size    .height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                        toolBar.barStyle = .blackTranslucent
                        toolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped3))]
                        self.view.addSubview(toolBar)
    }
    @objc func dayaction2(sender:UITapGestureRecognizer){
        popover4.removeFromSuperview()
        pickertype = 2
        picker = UIPickerView.init()
                        picker.delegate = self
                        picker.dataSource = self
                        picker.backgroundColor = UIColor.white
                        picker.setValue(UIColor.black, forKey: "textColor")
                        picker.autoresizingMask = .flexibleWidth
                        picker.contentMode = .center
                        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                        self.view.addSubview(picker)

                        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size    .height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                        toolBar.barStyle = .blackTranslucent
                        toolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped22))]
                        self.view.addSubview(toolBar)
    }
    @objc func houraction2(sender:UITapGestureRecognizer){
        popover4.removeFromSuperview()
        pickertype = 3
        picker = UIPickerView.init()
                        picker.delegate = self
                        picker.dataSource = self
                        picker.backgroundColor = UIColor.white
                        picker.setValue(UIColor.black, forKey: "textColor")
                        picker.autoresizingMask = .flexibleWidth
                        picker.contentMode = .center
                        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
                        self.view.addSubview(picker)

                        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size    .height - 300, width: UIScreen.main.bounds.size.width, height: 50))
                        toolBar.barStyle = .blackTranslucent
                        toolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped33))]
                        self.view.addSubview(toolBar)
    }
    @IBAction func optionbtn(_ sender: Any) {
        presentOptionsVC()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    @IBAction func closedpopover(_ sender: Any) {
         addeventbool = 1
         self.popover.removeFromSuperview()
    }
    @IBAction func closedpopover3(_ sender: Any) {
        addeventbool = 1
        selecttask = titlefield.text!
        selecttaskid = 0
         self.popover4.removeFromSuperview()
    }
    func closedpopover2(_ sender: Any) {
         self.popover2.removeFromSuperview()
    }
    @IBAction func popoverpressed(_ sender: Any) {
        popoverinit()
    }
    func popoverinit(){
        if popoverstatus3 == 1{
                       self.popover3.removeFromSuperview()
                       popoverstatus3 = 0
                   }
                   if popoverstatus3 == 0{
                       self.view.addSubview(popover3)
                       let superView = self.view.superview
                       superView!.addSubview(popover3)
                       popover3.translatesAutoresizingMaskIntoConstraints = false

                       NSLayoutConstraint.activate([

                               // 5
                               NSLayoutConstraint(item: popover3, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0),

                               // 6
                               NSLayoutConstraint(item: popover3, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0),

                               // 7
                               popover3.heightAnchor.constraint(equalToConstant:170),
                   
                               //8
                               popover3.widthAnchor.constraint(equalToConstant: 414)
                           ])
                       popoverstatus3 = 1
        }
    }
    func popoverinitexisting(){
       popover3.removeFromSuperview()
           if popoverstatus == 1{
               self.popover.removeFromSuperview()
               popoverstatus = 0
           }
           if popoverstatus == 0{
               self.view.addSubview(popover)
               let superView = self.view.superview
               superView!.addSubview(popover)
               popover.translatesAutoresizingMaskIntoConstraints = false

               NSLayoutConstraint.activate([

                       // 5
                       NSLayoutConstraint(item: popover, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0),

                       // 6
                       NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0),

                       // 7
                       popover.heightAnchor.constraint(equalToConstant:300),
           
                       //8
                       popover.widthAnchor.constraint(equalToConstant: 414)
                   ])
               popoverstatus = 1
       }
    }
    func popoverinitnew(){
       popover3.removeFromSuperview()
                 if popoverstatus4 == 1{
                     self.popover4.removeFromSuperview()
                     popoverstatus4 = 0
                 }
                 if popoverstatus4 == 0{
                     self.view.addSubview(popover4)
                     let superView = self.view.superview
                     superView!.addSubview(popover4)
                     popover4.translatesAutoresizingMaskIntoConstraints = false

                     NSLayoutConstraint.activate([

                             // 5
                             NSLayoutConstraint(item: popover4, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0),

                             // 6
                             NSLayoutConstraint(item: popover4, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0),

                             // 7
                             popover4.heightAnchor.constraint(equalToConstant:300),
                 
                             //8
                             popover4.widthAnchor.constraint(equalToConstant: 414)
                         ])
                     popoverstatus4 = 1
    }
    }
    @IBAction func addexisting(_ sender: Any) {
        popoverinitexisting()
    }
    @IBAction func addnew(_ sender: Any) {
        popoverinitnew()
    }
    //objc function for setting data to add
    @objc func onDoneButtonTapped() {
               toolBar.removeFromSuperview()
               picker.removeFromSuperview()
               titlelabel.text = ongoingtask[selectedpickerrow].taskname
            selecttask = ongoingtask[selectedpickerrow].taskname!
            selecttaskid = 1
               popoverinitexisting()
           }
            @objc func onDoneButtonTapped2() {
                toolBar.removeFromSuperview()
                picker.removeFromSuperview()
                daylabel.text = String(days[selectedpickerrow])
                selectdays = days[selectedpickerrow]
                popoverinitexisting()
            }
            @objc func onDoneButtonTapped3() {
                toolBar.removeFromSuperview()
                picker.removeFromSuperview()
                hourlabel.text = String(hours[selectedpickerrow])
                selecthours =  hours[selectedpickerrow]
                popoverinitexisting()
            }
    @objc func onDoneButtonTapped22() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        daylabel2.text = String(days[selectedpickerrow])
        selectdays = days[selectedpickerrow]
        popoverinitnew()
    }
    @objc func onDoneButtonTapped33() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        hourlabel2.text = String(hours[selectedpickerrow])
        selecthours =  hours[selectedpickerrow]
        popoverinitnew()
    }
           func numberOfComponents(in pickerView: UIPickerView) -> Int {
               return 1
           }

           func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                if pickertype == 1{
                    taskid = ongoingtask.count
                    return ongoingtask.count
                }
                if pickertype == 2{
                    return days.count
                }
                if pickertype == 3{
                    return hours.count
                }
                return 0
           }

           func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
               if pickertype == 1{
                    return ongoingtask[row].taskname
               }
               if pickertype == 2{
                    return String(days[row])
               }
               if pickertype == 3{
                   return String(hours[row])
               }
               return "fff"
           }

           func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
               selectedpickerrow = row
           }
    
    @IBAction func settingpressed(_ sender: Any) {
        presentOptionsVC()
    }
    override func prepare(for segue: UIStoryboardSegue,
              sender: Any?){
                if(segue.identifier == "seguetocalender")
                        {
                       let detailViewController = segue.destination as!
                        DefaultViewController1
                           detailViewController.projectItem =  projectItem
                      
                       }

          }
    // Support device orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
    }

    private func setupCalendarView() {
        calendarWeekView.baseDelegate = self

        if viewModel.currentSelectedData != nil {
            // For example only
            setupCalendarViewWithSelectedData()
        } else {
            calendarWeekView.setupCalendar(numOfDays: 3,
                                           setDate: Date(),
                                           allEvents: viewModel.eventsByDate,
                                           scrollType: .pageScroll,
                                           scrollableRange: (nil, nil))
        }

        // LongPress delegate, datasorce and type setup
        calendarWeekView.longPressDelegate = self
        calendarWeekView.longPressDataSource = self
        calendarWeekView.longPressTypes = [.addNew, .move]

     
        calendarWeekView.addNewDurationMins = 120
        calendarWeekView.moveTimeMinInterval = 15
    }
// set up calender default setting and delegate

    private func setupCalendarViewWithSelectedData() {
        guard let selectedData = viewModel.currentSelectedData else { return }
        calendarWeekView.setupCalendar(numOfDays: selectedData.numOfDays,
                                       setDate: selectedData.date,
                                       allEvents: viewModel.eventsByDate,
                                       scrollType: selectedData.scrollType,
                                       firstDayOfWeek: selectedData.firstDayOfWeek)
        calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
    }
}
// set selecteddata
extension LongPressViewController: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNaviBarTitle()
    }
}
// update nav bar
// LongPress core
extension LongPressViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
    // code for adding the event when long pressing the empty space
    func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
        if addeventbool == 1{
        var message = ""
            var users = ProjectTaskMemberDataManager.loadprojecttaskidandprojectid(taskid: taskid, projectid: (projectItem?.projectId!)!, assign: 1)
            if users.isEmpty == false{
                for item in users{
                    message += item.username! + "\n"
                }
            }
        var enddate = startDate.add(component: .hour, value: selecthours)
            enddate = enddate.add(component: .day, value: selectdays-1)
        let newEvent = AllDayEvent(id: "0",taskid:selecttaskid,projectid: (projectItem?.projectId!)!, title: selecttask, startDate: startDate, endDate: enddate,
                             location: message, isAllDay: false)
        ProjectEventDataManager.insertOrReplace(projectevent: newEvent)
        if viewModel.eventsByDate[startDate.startOfDay] == nil {
            viewModel.eventsByDate[startDate.startOfDay] = [AllDayEvent]()
        }
        viewModel.events.append(newEvent)
                    //print(viewModel.events.count)
        viewModel.events = ProjectEventDataManager.loadProjecteventsbyprojectid(projectid: (projectItem?.projectId!)!)
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
        }
    }
    // code for editing the event by longpressing the event
    func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
        guard let event = editingEvent as? AllDayEvent else { return }
        let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
        let selectedIndex = viewModel.events.firstIndex(where: { $0.id == event.id })!
        viewModel.events[selectedIndex].startDate = startDate
        viewModel.events[selectedIndex].endDate = startDate.add(component: .minute, value: duration)
        print(startDate)
        print(startDate.add(component: .minute, value: duration))
        ProjectEventDataManager.update(eventid: viewModel.events[selectedIndex].id, startdate: viewModel.events[selectedIndex].startDate, enddate: viewModel.events[selectedIndex].endDate)
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)
        weekView.forceReload(reloadEvents: viewModel.eventsByDate)
    }
    // the start animation of adding event longpress and to set up what data to show in the animation
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        if addeventbool == 1{
        
            if let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? EventCell {
                view.titleLabel.text = selecttask
                return view
            }
            return UIView()
        }
        return UIView()
    }
}
extension LongPressViewController {

  func showToast(message : String, font: UIFont) {

      let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
      toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      toastLabel.textColor = UIColor.white
      toastLabel.font = font
      toastLabel.textAlignment = .center;
      toastLabel.text = message
      toastLabel.alpha = 1.0
      toastLabel.layer.cornerRadius = 10;
      toastLabel.clipsToBounds  =  true
      self.view.addSubview(toastLabel)
      UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
           toastLabel.alpha = 0.0
      }, completion: {(isCompleted) in
          toastLabel.removeFromSuperview()
      })
  } }
// toast but i stop using it
extension LongPressViewController: OptionsViewDelegate {

    func setupBasic() {
        // Add this to fix lower than iOS11 problems
        self.automaticallyAdjustsScrollViewInsets = false
    }

    private func setupNaviBar() {
        updateNaviBarTitle()
        let optionsButton = UIButton(type: .system)
        optionsButton.setImage(#imageLiteral(resourceName: "1"), for: .normal)
        optionsButton.frame.size = CGSize(width: 25, height: 25)
        if #available(iOS 11.0, *) {
            optionsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            optionsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        optionsButton.addTarget(self, action: #selector(presentOptionsVC), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: optionsButton)
    }
    //update nav gar
    @objc func presentOptionsVC() {
        guard let optionsVC = UIStoryboard(name: "Seb_Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as? ExampleOptionsViewController else {
            return
        }
        let optionsViewModel = OptionsViewModel(selectedData: getSelectedData())
        optionsVC.viewModel = optionsViewModel
        optionsVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: optionsVC)
        self.present(navigationVC, animated: true, completion: nil)
    }
    // show a new long press viewcontroller when you change the setting of the calendar
    private func getSelectedData() -> OptionsSelectedData {
        let numOfDays = calendarWeekView.numOfDays!
        let firstDayOfWeek = numOfDays == 7 ? calendarWeekView.firstDayOfWeek : nil
        viewModel.currentSelectedData = OptionsSelectedData(
                                                            date: calendarWeekView.initDate.add(component: .day, value: numOfDays),
                                                            numOfDays: numOfDays,
                                                            scrollType: calendarWeekView.scrollType,
                                                            firstDayOfWeek: firstDayOfWeek,
                                                            hourGridDivision: calendarWeekView.flowLayout.hourGridDivision,
                                                            scrollableRange: calendarWeekView.scrollableRange)
        return viewModel.currentSelectedData
    }
// get the data from the optioncontroller
    func finishUpdate(selectedData: OptionsSelectedData) {

        // Update numOfDays
        if selectedData.numOfDays != viewModel.currentSelectedData.numOfDays {
            calendarWeekView.numOfDays = selectedData.numOfDays
            calendarWeekView.refreshWeekView()
        }
        // Update Date
        if selectedData.date != viewModel.currentSelectedData.date {
            calendarWeekView.updateWeekView(to: selectedData.date)
        }
        // Update Scroll Type
        if selectedData.scrollType != viewModel.currentSelectedData.scrollType {
            calendarWeekView.scrollType = selectedData.scrollType
            // If you want to change the scrollType without forceReload, you should call setHorizontalEdgesOffsetX
            calendarWeekView.setHorizontalEdgesOffsetX()
        }
        // Update FirstDayOfWeek
        if selectedData.firstDayOfWeek != viewModel.currentSelectedData.firstDayOfWeek {
            calendarWeekView.updateFirstDayOfWeek(setDate: selectedData.date, firstDayOfWeek: selectedData.firstDayOfWeek)
        }
        // Update hourGridDivision
        if selectedData.hourGridDivision != viewModel.currentSelectedData.hourGridDivision {
            calendarWeekView.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
        }
        // Update scrollableRange
        if selectedData.scrollableRange != viewModel.currentSelectedData.scrollableRange {
            calendarWeekView.scrollableRange = selectedData.scrollableRange
        }
    }

    private func updateNaviBarTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        self.navigationItem.title = dateFormatter.string(from: calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays))
    }
   
}
