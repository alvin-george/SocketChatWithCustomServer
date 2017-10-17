//
//  UIAppExtensions.swift
//  EyaalZayeed
//
//  Created by apple on 14/06/17.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension String{
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    init(_ value:Int){
        
        self.init(describing:value)
    }
    func toInt(optionalString:String?) -> Int {
        
        let resultInt:Int = Int()
        let optionalString: String? = optionalString
        
        if let string = optionalString{
            let resultInt = Int(string)
        }
        return resultInt
    }
}

extension UIView {
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    func makeRoundedEdge()
    {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.layer.borderColor  =  UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
    func setCardView(view : UIView){
        
        view.layer.cornerRadius = 5.0
        view.layer.borderColor  =  UIColor.clear.cgColor
        view.layer.borderWidth = 5.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor =  UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width:5, height: 5)
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
    }
//    func setViewAnimted(view: UIView, hidden: Bool) {
//        UIView.transition(with: view, duration: 0.5, options: .showHideTransitionViews, animations: { _
//            in
//            view.isHidden = hidden
//        }, completion: nil)
//    }
    func addLeftTriangle(colour:UIColor)
    {
        UIGraphicsGetCurrentContext()?.beginPath()
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: self.frame.minX, y: self.frame.minY))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.maxY))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.minY))
        UIGraphicsGetCurrentContext()?.closePath()
        
        UIGraphicsGetCurrentContext()?.setFillColor(colour.cgColor)
        UIGraphicsGetCurrentContext()?.fillPath()
    }
    func addRightTriangle(colour:UIColor)
    {
        UIGraphicsGetCurrentContext()?.beginPath()
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: self.frame.minX, y: self.frame.minY))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.minY))
        UIGraphicsGetCurrentContext()?.closePath()

        UIGraphicsGetCurrentContext()?.setFillColor(colour.cgColor)
        UIGraphicsGetCurrentContext()?.fillPath()

    }
    
}
extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
    
}
extension UIImage{
    
    func saveImageToDocumentDirectory(image:UIImage)
    {
//        if (image != nil){
//            let data:Data = UIImagePNGRepresentation(image)!
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            data.write(to: "\(documentsPath)profilePic", options: [])
//        }
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profilePic.png")
        
        do {
            try UIImagePNGRepresentation(image)!.write(to: fileURL, options: .atomic)
        } catch {
            print(error)
        }
        
        
    }
    func getImageFromDocumentDirectory(imageName: String?) -> UIImage{
        
        var retreivedImage =  UIImage()
        
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let readData = try NSData(contentsOfFile: "\(documentsPath)\(String(describing: imageName))", options: [])
            retreivedImage = UIImage(data: readData as Data)!
            
        }
        catch {
            print("Error")
        }
        return retreivedImage
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}
extension UIButton{
    
    func makeRoundedEdge(boarderWidth:CGFloat?, borderColour: UIColor?,cornerRadius:CGFloat?)
    {
        layer.cornerRadius = cornerRadius!
        layer.borderWidth = boarderWidth!
        layer.borderColor = borderColour?.cgColor
    }
    
}
extension UITextField{
    func makeRoundedEdge(boarderWidth:CGFloat?, borderColour: UIColor?,cornerRadius:CGFloat?)
    {
        layer.cornerRadius = cornerRadius!
        layer.borderWidth = boarderWidth!
        layer.borderColor = borderColour?.cgColor
    }
}
extension UISearchBar {
    
    func setMagnifyingGlassColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
    
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
}

//*************************

extension Date {
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    var timeStamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    init(timeStampToBeConveretedToDate: UInt64) {
        self.init(timeIntervalSince1970: Double(timeStampToBeConveretedToDate)/10_000_000 - 62_135_596_800)
    }
    func getCurrentYear() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    func convertToDate(timeStamp : Double?) -> String {
        
        let date = Date(timeIntervalSince1970: timeStamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let stringDate = dateFormatter.string(from: date)
        return stringDate
        
    }
    func convertToDayDateAndYear(date :Date?) ->String {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "MMMM dd, yyyy - EEEE"
        let dateString: String = dateFormatter.string(from: date!)
        return dateString
    }
    func dateBeforeOrAfterFromToday(numberOfDays :Int?) -> Date {
        
        let resultDate = Calendar.current.date(byAdding: .day, value: numberOfDays!, to: Date())!
        return resultDate
    }
    func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date]
    {
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        return datesArray
    }
    
    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date]
    {
        let calendar = Calendar.current
        var datesArray: [Date] =  [Date]()
        
        for i in 0 ... (value-1) {
            if let newDate = calendar.date(byAdding: addbyUnit, value: i, to: startDate!) {
                datesArray.append(newDate)
            }
        }
        
        return datesArray
    }
    
    func convertDatesArrayToStringFormat(dates : [Date]) ->[String]
    {
        var formattedArray =  [String]()
        
        var myString =  String()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        for i in 0 ... dates.count-1 {
            
            myString = dateFormatter.string(from: dates[i])
            
            formattedArray.append(myString)
            
        }
        
        return formattedArray
    }
    func getDateNumberArrayFromDates(dates : [Date]) -> [String]
    {
        
        var formattedArray =  [String]()
        var myString =  String()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        for i in 0 ... dates.count-1 {
            
            myString = dateFormatter.string(from: dates[i])
            
            formattedArray.append(myString)
            
        }
        return formattedArray
        
    }
    func getMonthArrayFromDates(dates : [Date]) -> [String]{
        
        var formattedArray =  [String]()
        var myString =  String()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        for i in 0 ... dates.count-1 {
            
            myString = dateFormatter.string(from: dates[i])
            
            formattedArray.append(myString)
            
        }
        return formattedArray
        
    }
    func convertToDateString(date:Date?, format: String?)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString: String = dateFormatter.string(from: date!)
        return dateString
    }
    
    func getDayNameArrayFromDates(dates : [Date]) -> [String]{
        
        var formattedArray =  [String]()
        var myString =  String()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for i in 0 ... dates.count-1 {
            
            myString = dateFormatter.string(from: dates[i])
            
            formattedArray.append(myString)
            
        }
        return formattedArray
        
    }
    func getTimeFromTimestamp (timeStamp: Double?) -> String{
        
        let unixTimestamp = timeStamp
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.timeStyle = .short
        dateFormatter.locale = NSLocale.current
        
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
}


extension Data {
    func elements <T> () -> [T] {
        return withUnsafeBytes {
            Array(UnsafeBufferPointer<T>(start: $0, count: count/MemoryLayout<T>.size))
        }
    }
}
extension NSMutableArray{
    
    func convertToNSData(mutableArray: NSMutableArray) -> NSData{
        
        let swiftArray: [String] = mutableArray.flatMap({ $0 as? String })
        let swiftArrayData = Data(buffer: UnsafeBufferPointer(start: swiftArray, count: swiftArray.count))
        let convertedArray: [String] = swiftArrayData.elements()
        let convertedData = NSKeyedArchiver.archivedData(withRootObject: convertedArray) as NSData
        
        return convertedData
        
    }
}
extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
    func indexesOf<T : Equatable>(object:T) -> [Int] {
        var result: [Int] = []
        for (index,obj) in enumerated() {
            if obj as! T == object {
                result.append(index)
            }
        }
        return result
    }
}

extension Double {
    
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

//For User session
//extension NSCache {
//    class var sharedInstance : NSCache {
//        struct Static {
//            static let instance : NSCache = NSCache()
//        }
//        return Static.instance
//    }
//}

extension UserDefaults{
    class var sharedInstance : UserDefaults {
        struct Static {
            static let instance : UserDefaults = UserDefaults()
        }
        return Static.instance
    }
}
//extension URL {
//    static var documentsDirectory: URL {
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        return try! documentsDirectory.asURL()
//    }
//    
//    static func urlInDocumentsDirectory(with filename: String) -> URL {
//        return documentsDirectory.appendingPathComponent(filename)
//    }
//}
