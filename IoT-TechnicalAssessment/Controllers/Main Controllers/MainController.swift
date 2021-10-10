//
//  MyController.swift
//  Created by shendy on 5/31/20.
//

import UIKit
import SystemConfiguration
import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage
import Spring
import ImageIO
import Lottie


class MainController {
    
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
    public static let defaultLang = "ar"
    
    public static func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    public static func isEmptyString(text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        if text == "" {
            return true
        }
        if text.count == 0 {
            return true
        }
        return false
    }
    
    public static func openUrl(mainUrl:String,scondaryUrl:String , schema:String) {
        
        let strUrl: String = mainUrl
        
        if UIApplication.shared.canOpenURL(URL(string: schema)!) {
            let url = URL(string: strUrl)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            
            if let url = URL(string: scondaryUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    public static func makeCall(_ phone:String) {
        if let url  = URL(string:"tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(url)) {
                application.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    public static func getDeviceLocale() -> String {
        let currentLocale = NSLocale.current.languageCode!
        return currentLocale
    }
    public static func isConnectedToInternet() -> Int{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return 0
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return 0
        }
        
        let isReachable = flags.contains(.reachable)
        
        if isReachable{
            return 1
        }else{
            return 0
            
        }
    }
    
    public static func viewAlertDialog(vc:UIViewController, title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    public static func viewLogoutAlertDialog(vc:UIViewController, title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            appLogout()
            pushViewController(identifier: "welcome", vc: vc ,timeSeconds: 0)
            
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    public static func calculateAge(birthday:String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        if birthdayDate != nil {
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let calcAge = calendar.components(.year, from: birthdayDate!, to: Date(), options: [])
            let age = calcAge.year
            return age!
        }
        
        return 0
    }
    public static func differenceBetweenDates(_ date1:Date,_ date2:Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let days = components.day ?? 0
        return days
    }
    
    public static func stringToDate(sDate:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = formatter.date(from: sDate)
        return date!
    }
    public static func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    public static func getFullDateStr(date:Date) -> String{
        //format style :  31-10-2017
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let today = formatter.string(from: date)
        return today
    }
    public static func getDateOnly(date:Date) -> String{
        //format style :  31-10-2017
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let today = formatter.string(from: date)
        return today
    }
    public static func getTimeOnly(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let dateString = formatter.string(from: date)
        return dateString
    }
    public static func getDateNameOnly(date : Date) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEE"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let today = formatter.string(from:date)
        return today
    }
    
    public static func getNextDate(date:Date) -> Date {
        let dayToAdd = 60 * 60 * 24
        let nextDate = date.addingTimeInterval(TimeInterval(dayToAdd))
        return nextDate
    }
    public static func getPreviousDate(date:Date) -> Date{
        let dayToAdd = 60 * 60 * 24 * -1
        let nextDate = date.addingTimeInterval(TimeInterval(dayToAdd))
        return nextDate
    }
    
    public static func gotoPage(identifier: String, vc: UIViewController , timeSeconds: Double = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeSeconds) {
            vc.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    public static func pushViewController(identifier: String, vc: UIViewController , timeSeconds: Double = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeSeconds) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: identifier)
            vc.present(nextViewController, animated:true, completion:nil)
        }
    }
    public static func showActivityIndicator(vc: UIViewController,nameGIF:String){
        vc.view.isUserInteractionEnabled = false
        let screenSize: CGRect = UIScreen.main.bounds
        
        //        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        //        activityView.center = vc.view.center
        //        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        //        myView.setBlurViewDark()
        //        myView.tag = 999
        //        myView.addSubview(activityView)
        //        vc.view.addSubview(myView)
        //        activityView.startAnimating()
        
        var animationView = AnimationView()
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        myView.tag = 999
        myView.setBlurView()
        
        animationView = .init(name: nameGIF)
        animationView.frame = vc.view.bounds
        animationView.contentMode = .center
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        myView.addSubview(animationView)
        
        vc.view.addSubview(myView)
        animationView.play()
    }
    public static func showSplashGIF(vc: UIViewController,nameGIF:String){
        vc.view.isUserInteractionEnabled = false
        let screenSize: CGRect = UIScreen.main.bounds
        var animationView = AnimationView()
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        myView.tag = 999
        //        myView.setBlurViewDark()
        
        animationView = .init(name: nameGIF)
        animationView.frame = vc.view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        myView.addSubview(animationView)
        
        vc.view.addSubview(myView)
        animationView.play()
    }
    public static func hideActivityIndicator(vc: UIViewController , timeSeconds: Double = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeSeconds) {
            
            vc.view.isUserInteractionEnabled = true
            let subViews = vc.view.subviews
            for subview in subViews{
                if subview.tag == 999 {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    public static func clearNavigationBar(vc: UIViewController){
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.view.backgroundColor = .clear
    }
    
    public static func postRequest(apiURL:String ,params : Parameters, _headers3 : HTTPHeaders, vc: UIViewController, completion:((JSON,String,Int)->Void)!){
        
        Alamofire.request(apiURL, method: .post, parameters: params,
                          encoding: URLEncoding.httpBody, headers: _headers3)
            .responseJSON { response  in
                if(response.result.isSuccess)
                {
                    let mainJSON = JSON(response.result.value!)
                    completion(mainJSON,"\(response.result.value ?? "" )",response.response!.statusCode)
                    
                }
                else
                {
                    if   let resp = response.result.value as? NSDictionary {
                        let message = resp["message"] as? String ?? ""
                        completion([:],message,response.response!.statusCode)
                    }
                    print("main controller error \(response.result.error?.localizedDescription ?? "")")
                }
            }
    }
    public static func getRequest(apiURL:String ,params : Parameters, _headers3 : HTTPHeaders, vc: UIViewController, completion:((JSON,String,Int)->Void)!){
        
        Alamofire.request(apiURL, method: .get, parameters: params,
                          encoding: URLEncoding.httpBody, headers: _headers3)
            .responseJSON { response  in
                if(response.result.isSuccess)
                {
                    let mainJSON = JSON(response.result.value!)
                    completion(mainJSON,"\(response.result.value ?? "" )",response.response!.statusCode)
                    
                }
                else
                {
                    if   let resp = response.result.value as? NSDictionary {
                        let message = resp["message"] as? String ?? ""
                        completion([:],message,response.response!.statusCode)
                    }
                    print("main controller error \(response.result.error?.localizedDescription ?? "")")
                }
            }
    }
    
    public static func appLogout(){
        
        //        FacebookSignInManager.logoutFromFacebook()
        
        let lang = UserDefaults.standard.string(forKey: "lang")
        let fcm = UserDefaults.standard.object(forKey: "fcmtoken") as? String ?? ""
        let domain = Bundle.main.bundleIdentifier!
        
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(lang, forKey: "lang")
        UserDefaults.standard.set(fcm, forKey: "fcmtoken")
        
        if lang == "ar"{
            Language.language = Language.arabic
        }else{
            Language.language = Language.english
        }
    }
    public static func stringToColorFunc(mainString: String,stringToColor: String,newColor: UIColor) -> NSAttributedString {
        let range = (mainString as NSString).range(of: stringToColor)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: newColor, range: range)
        return mutableAttributedString
    }
}


typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())
class ImageCacheLoader {
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    
    init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            /* You need placeholder image in your assets,
             if you want to display a placeholder to user */
            let placeholder = #imageLiteral(resourceName: "Group 188")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            let url: URL! = URL(string: imagePath)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                if let data = try? Data(contentsOf: url) {
                    let img: UIImage! = UIImage(data: data)
                    if img != nil{
                        self.cache.setObject(img, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            completionHandler(img)
                        }
                    }
                }
            })
            task.resume()
        }
    }
}

extension UIViewController{
    func hideKeboardWhenTappedAround(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func ShadowTextField(){
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
    }
    
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UITextView {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func addBottomBorderWithColor(color: UIColor, width: CGFloat,viewWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height, width: viewWidth, height: width)
        self.layer.addSublayer(border)
    }
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func ShadowUIView(){
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
    }
    func dropShadow(color: UIColor, opacity: Float = 0.1, width:Int,height:Int, radius: CGFloat = 0, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    func applyGradient(colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    func setBlurViewDark(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func setBlurView(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func rotateView() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIButton {
    func ShadowUIButton(){
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
    }
    
    @objc var substituteFontName : String {
        get { return (self.titleLabel?.font.fontName)! }
        set {
            let fontNameToTest = self.titleLabel?.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest!.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest!.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest!.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest!.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.titleLabel?.font = UIFont(name: fontName, size: (self.titleLabel?.font.pointSize)!)
        }
    }
}

extension UILabel {
    @objc var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
    func setStrikethroughStyle(text:String) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
    func setUnderLine() {
        let textRange = NSMakeRange(0, self.text!.count)
        let attributedText = NSMutableAttributedString(string: self.text!)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value:NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        
        self.attributedText = attributedText
    }
    
}

extension DateFormatter {
    func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if Language.language == Language.english{
            
            if components.year! >= 2 {
                result = "\(components.year!) years ago"
                
            } else if components.year! >= 1 {
                result = "year ago"
                
            } else if components.month! >= 2 {
                result = "\(components.month!) monthes ago"
                
            } else if components.month! >= 1 {
                result = "month ago"
                
            } else if components.weekOfYear! >= 2 {
                result = "\(components.weekOfYear!) weeks ago"
                
            } else if components.weekOfYear! >= 1 {
                result = "week ago"
                
            } else if components.day! >= 2 {
                result = "\(components.day!) days ago"
                
            } else if components.day! >= 1 {
                result = "day ago"
                
            } else if components.hour! >= 2 {
                result = "\(components.hour!) hrs ago"
                
            } else if components.hour! >= 1 {
                result = "1 hr"
                
            } else if components.minute! >= 2 {
                result = "\(components.minute!) mins ago"
                
            } else if components.minute! >= 1 {
                result = "1 min ago"
                
            } else if components.second! >= 3 {
                result = "\(components.second!) sec ago"
            } else {
                result = "now"
            }
        }else{
            
            if components.year! >= 2 {
                result = "سنين \(components.year!) مضت  "
                
            } else if components.year! >= 1 {
                result = "منذ عام"
                
            } else if components.month! >= 2 {
                result = " منذ \(components.month!) اشهر "
                
            } else if components.month! >= 1 {
                result = "منذ شهر"
                
            } else if components.weekOfYear! >= 2 {
                result = " منذ \(components.weekOfYear!) أسابيع "
                
            } else if components.weekOfYear! >= 1 {
                result = "منذ أسبوع"
                
            } else if components.day! >= 2 {
                result = " أيام \(components.day!) مضت "
                
            } else if components.day! >= 1 {
                result = "منذ يوم"
                
            } else if components.hour! >= 2 {
                result = " منذ \(components.hour!) ساعات  "
                
            } else if components.hour! >= 1 {
                result = "ساعة"
                
            } else if components.minute! >= 2 {
                result = "دقائق \(components.minute!) مضت  "
                
            } else if components.minute! >= 1 {
                result = "قبل دقيقة واحدة"
                
            } else if components.second! >= 3 {
                result = " منذ \(components.second!) ثوانى  "
            } else {
                result = "حاليا"
            }
        }
        
        return result
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var today:  Date { return Date().today }
    static var threedays:  Date { return Date().threedayss }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var threedayss: Date {
        return Calendar.current.date(byAdding: .day, value: 3, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension UIColor {
    static func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

extension UIStoryboard {
    func instanceVC<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return vc
    }
}

extension UITableView {
    func dequeueTVCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return cell
    }
    func registerCell(id: String) {
        self.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
}

extension UICollectionView {
    func dequeueCVCell<T: UICollectionViewCell>(indexPath:IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return cell
    }
    
    func registerCell(id: String) {
        self.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    }
}

extension String{
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isUrlValid : Bool {
        if let url = URL.init(string: self){
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    func ArNumberToEn() -> String {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let finaltxtNo = Formatter.number(from: self)
        return "00\(finaltxtNo!)"
    }
    func replacePlusInCountruCode() -> String {
        let result = self.replacingOccurrences(of: "+", with: "00")
        return  "\(result)"
    }
    var replaceZerosInCountruCode : String {
        let result = self.dropFirst(2).description
        return  "+\(result)"
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension UINavigationItem{
    func hideBackWord()  {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.backBarButtonItem = backItem
    }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    case topRight
    case bottom
    
    var startPoint : CGPoint {
        get { return points.startPoint }
    }
    
    var endPoint : CGPoint {
        get { return points.endPoint }
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 1,y: 1))
            case .horizontal:
                return (CGPoint.init(x: 0.0,y: 0.5), CGPoint.init(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
            case .topRight:
                return (CGPoint.init(x: 1.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
            case .bottom:
                return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 0.0,y: 0.0))
                
            }
        }
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
                    print("SwiftGif: This image named \"\(name)\" does not exist")
                    return nil
                }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            sum = sum / 5 // change for gif time
            return sum
        }()
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
    
    func setFontSize(size: CGFloat)
    {
        let textFieldInsideUISearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(size)
    }
    
    func setMagnifyingGlassColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

