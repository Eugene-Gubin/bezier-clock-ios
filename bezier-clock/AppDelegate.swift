//
//  AppDelegate.swift
//  bezier-clock
//
//  Created by Евгений Губин on 18.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

import UIKit

// никаких main.m, вместо этого аннотация
// swift-файлы принадлежат какому-то модулю
// по умолчанию модуль называется так же, как и проект
// на данный момент не стоит использовать в названии ничего кроме латиницы и _,
// иначе будут ошибки компиляции при попытке использовать swift-классы из Obj-C
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        application.idleTimerDisabled = true
        
        return true
    }
}

