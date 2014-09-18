//
//  SwDigitView.swift
//  bezier-clock
//
//  Created by Евгений Губин on 16.09.14.
//  Copyright (c) 2014 Simbirsoft Ltd. All rights reserved.
//

import UIKit

public class DigitView: UIView {
    // 1. очень модный синтаксис объявления массива
    // 2. статические массивы пока не поддерживаются
    // 3. тем не менее, этот неизменяем по определению (let)
    // 3.1. в первых бетах это означало, что длину менять нельзя, а содержимое можно,
    // но потом разработчикам, видимо, сказали, что время безудержного креатива прошло
    // и отобрали вещества, после чего неизменяемые массивы стали действительно неизменяемыми
    private let sc_digitsData: [[CGFloat]] = [
    [254.0,  47.0, 159.0,  84.0, 123.0, 158.0, 131.0, 258.0, 139.0, 358.0, 167.0, 445.0, 256.0, 446.0, 345.0, 447.0, 369.0, 349.0, 369.0, 275.0, 369.0, 201.0, 365.0,  81.0, 231.0,  75.0],
    [138.0, 180.0, 226.0,  99.0, 230.0,  58.0, 243.0,  43.0, 256.0,  28.0, 252.0, 100.0, 253.0, 167.0, 254.0, 234.0, 254.0, 194.0, 255.0, 303.0, 256.0, 412.0, 254.0, 361.0, 255.0, 424.0],
    [104.0, 111.0, 152.0,  55.0, 208.0,  26.0, 271.0,  50.0, 334.0,  74.0, 360.0, 159.0, 336.0, 241.0, 312.0, 323.0, 136.0, 454.0, 120.0, 405.0, 104.0, 356.0, 327.0, 393.0, 373.0, 414.0],
    [96.0, 132.0, 113.0,  14.0, 267.0,  17.0, 311.0, 107.0, 355.0, 197.0, 190.0, 285.0, 182.0, 250.0, 174.0, 215.0, 396.0, 273.0, 338.0, 388.0, 280.0, 503.0, 110.0, 445.0,  93.0, 391.0],
    [374.0, 244.0, 249.0, 230.0, 192.0, 234.0, 131.0, 239.0,  70.0, 244.0, 142.0, 138.0, 192.0,  84.0, 242.0,  30.0, 283.0, -30.0, 260.0, 108.0, 237.0, 246.0, 246.0, 435.0, 247.0, 438.0],
    [340.0,  52.0, 226.0,  42.0, 153.0,  44.0, 144.0,  61.0, 135.0,  78.0, 145.0, 203.0, 152.0, 223.0, 159.0, 243.0, 351.0, 165.0, 361.0, 302.0, 371.0, 439.0, 262.0, 452.0, 147.0, 409.0],
    [301.0,  26.0, 191.0, 104.0, 160.0, 224.0, 149.0, 296.0, 138.0, 368.0, 163.0, 451.0, 242.0, 458.0, 321.0, 465.0, 367.0, 402.0, 348.0, 321.0, 329.0, 240.0, 220.0, 243.0, 168.0, 285.0],
    [108.0,  52.0, 168.0,  34.0, 245.0,  42.0, 312.0,  38.0, 379.0,  34.0, 305.0, 145.0, 294.0, 166.0, 283.0, 187.0, 243.0, 267.0, 231.0, 295.0, 219.0, 323.0, 200.0, 388.0, 198.0, 452.0],
    [243.0, 242.0, 336.0, 184.0, 353.0,  52.0, 240.0,  43.0, 127.0,  34.0, 143.0, 215.0, 225.0, 247.0, 307.0, 279.0, 403.0, 427.0, 248.0, 432.0,  93.0, 437.0, 124.0, 304.0, 217.0, 255.0],
    [322.0, 105.0, 323.0,   6.0, 171.0,  33.0, 151.0,  85.0, 131.0, 137.0, 161.0, 184.0, 219.0, 190.0, 277.0, 196.0, 346.0, 149.0, 322.0, 122.0, 298.0,  95.0, 297.0, 365.0, 297.0, 448.0]
    ];
    
    // В Swift у объекта нет полей - только свойства.
    // Свойства могут быть: вычисляемыми (computed),
    var color: UIColor {
        // объявление в духе популярных языков,
        // но есть ещё willSet, didSet для наблюдения
        get {
            return UIColor(CGColor: shapeLayer.strokeColor)
        }
        set {
            shapeLayer.strokeColor = newValue.CGColor
        }
    }
    
    // хранимыми (stored),
    private var _digit: uint = 0
    var digit: uint {
        get {
            return _digit
        }
        set {
            // именованные параметры, вместо селекторов Obj-C
            setDigit(newValue, animated: false)
        }
    }
    
    var thickness: Float {
        get {
            return Float(shapeLayer.lineWidth)
        }
        set {
            shapeLayer.lineWidth = CGFloat(newValue)
        }
    }
    
    // вычисляемыми свойствами класса (хранимые не поддерживаются)
    class var animationDuration : Double {
        get {
            return 0.5;
        }
    }
    
    var shapeLayer: CAShapeLayer {
        return self.layer as CAShapeLayer
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    // обязательный инициализатор: такой инициализатор должен иметь каждый наследник
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }
    
    func internalInit() {
        shapeLayer.fillColor   = UIColor.clearColor().CGColor;
        shapeLayer.strokeColor = UIColor.blackColor().CGColor;
        shapeLayer.lineWidth   = 2.0;
        shapeLayer.lineCap     = kCALineCapRound;
        shapeLayer.lineJoin    = kCALineJoinRound;
        
        setupPathWithDigit(digit, animated: false)
    }
    
    func setDigit(value: uint, animated: Bool) {
        if (_digit != value) {
            _digit = value % 10
            setupPathWithDigit(_digit, animated: animated)
        }
    }
    
    private func setupPathWithDigit(digit: uint, animated: Bool) {
        let data = sc_digitsData[Int(digit)]
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(data[0], data[1]))
        
        for (var index = 0; index < 4; index++) {
            let baseIndex = 2 + index * 6;
            
            path.addCurveToPoint(
                CGPointMake(data[baseIndex + 4], data[baseIndex + 5]),
                controlPoint1:CGPointMake(data[baseIndex + 0], data[baseIndex + 1]),
                controlPoint2:CGPointMake(data[baseIndex + 2], data[baseIndex + 3]));
        }
        
        let ratioX = self.bounds.size.width  / 500.0
        let ratioY = self.bounds.size.height / 500.0
        let ratio  = min(ratioX, ratioY);
        let deltaX = (ratioX - ratio) * 500.0 / 2.0
        let deltaY = (ratioY - ratio) * 500.0 / 2.0
        
        let matrix = CGAffineTransformConcat(
            CGAffineTransformMakeScale(ratio, ratio),
            CGAffineTransformMakeTranslation(deltaX, deltaY))
        
        path.applyTransform(matrix)
        
        if (animated) {
            let animation = CABasicAnimation(keyPath: "path")
            
            animation.duration       = DigitView.animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.fromValue      = shapeLayer.valueForKeyPath(animation.keyPath)
            animation.toValue        = path.CGPath
            
            shapeLayer.addAnimation(animation, forKey:"path.animation")
            shapeLayer.setValue(animation.toValue, forKeyPath:animation.keyPath)
        } else {
            shapeLayer.path = path.CGPath
        }
    }
    
    override public class func layerClass() -> AnyClass {
        // метакласс: возвращаем ссылку не на экземляр класса, а на сам класс
        return CAShapeLayer.self
    }
}
