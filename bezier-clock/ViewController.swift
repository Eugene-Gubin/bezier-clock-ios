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
        self.view.backgroundColor = UIColor.black
        
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
        
        let units = Set<Calendar.Component>([.hour, .year, .minute, .second])
        let date = NSDate(timeIntervalSinceNow: 1.0)
        let components = NSCalendar.current.dateComponents(units, from: date as Date)
        
        // optional chaining: если self == null, то метод вызыван не будет
        self?.digitViews[0].setDigit(value: uint(components.hour! / 10), animated: animated)
        self?.digitViews[1].setDigit(value: uint(components.hour! % 10), animated: animated)
        self?.digitViews[2].setDigit(value: uint(components.minute! / 10), animated: animated)
        self?.digitViews[3].setDigit(value: uint(components.minute! % 10), animated: animated)
        self?.digitViews[4].setDigit(value: uint(components.second! / 10), animated: animated)
        self?.digitViews[5].setDigit(value: uint(components.second! % 10), animated: animated)

        let time = CFAbsoluteTimeGetCurrent()
        var delta = ceil(time) - time - DigitView.animationDuration
        
        while (delta < 0.0) {
            delta += 1.0
        }
        
        let dtime = DispatchWallTime.now() + DispatchTimeInterval.seconds(Int(delta))
        DispatchQueue.main.asyncAfter(wallDeadline: dtime, qos:.unspecified, flags: [], execute: {
            if let cb = self?.clockUpdate {
                cb(true)
            }
        })

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
