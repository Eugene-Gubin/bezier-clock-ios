//
//  SwViewController.swift
//  bezier-clock
//
//  Created by Евгений Губин on 17.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Outlet collection - это просто массив (глядите какой модный синтаксис)
    @IBOutlet var digitViews: [DigitView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup appearance
        self.view.backgroundColor = UIColor.blackColor()
        
        // и в отличии от NSArray рассылку сообщений (setValue:) он не поддерживает,
        // поэтому используем for-in и долой строковые константы
        for dw in digitViews {
            dw.color = UIColor(red:240.0/255.0, green:100.0/255.0, blue:0.0, alpha:1.0)
            dw.thickness = 3.0
        }
        
        // sort views
        // вместо NSPredicate используем trailing closures
        digitViews.sort { $0.tag < $1.tag }
        
        // update loop
        clockUpdate(false)
    }

    // тут подход тот же, что и в Obj-C, но инициализация ленивая синтаксически,
    // а тип объявлен прямо по месту
    lazy var clockUpdate: (Bool) -> Void = {
        // вместо __weak __typeof используем capture list
        // слабая ссылка нужна, т.к. ViewController через свойство clockUpdate
        // ссылается на замыкание, а замыкание ссылается на него
        [weak self] (animated: Bool) in
        
        let units =
            NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit
        let date = NSDate(timeIntervalSinceNow: 1.0)
        let components = NSCalendar.currentCalendar().components(units, fromDate: date)
        
        // optional chaining: если self == null, то метод вызыван не будет
        self?.digitViews[0].setDigit(uint(components.hour   / 10), animated: animated)
        self?.digitViews[1].setDigit(uint(components.hour   % 10), animated: animated)
        self?.digitViews[2].setDigit(uint(components.minute / 10), animated: animated)
        self?.digitViews[3].setDigit(uint(components.minute % 10), animated: animated)
        self?.digitViews[4].setDigit(uint(components.second / 10), animated: animated)
        self?.digitViews[5].setDigit(uint(components.second % 10), animated: animated)
        
        let time = CFAbsoluteTimeGetCurrent()
        var delta = ceil(time) - time - DigitView.animationDuration
        
        while (delta < 0.0) {
            delta += 1.0
        }
        
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(delta * Double(NSEC_PER_SEC)))
        dispatch_after(dtime, dispatch_get_main_queue()) {
            // тоже optional chaining но с проверкой наличия
            if let cb = self?.clockUpdate {
                cb(true)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
