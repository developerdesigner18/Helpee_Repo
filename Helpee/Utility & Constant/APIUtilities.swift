import UIKit
import Alamofire
//import SVProgressHUD
import ReachabilitySwift

class APIUtilities: NSObject {
    
    class var sharedInstance : APIUtilities {
        struct Static {
            static let instance : APIUtilities = APIUtilities()
        }
        return Static.instance
    }
    
    //MARK:- Alamofire methods
    
    func POSTTHEAPI(str : String) {
        
    }
    
    //MARK:- GET
    func GetAPICallWith(url:String, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return;
        }
        
        let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            //            .responseString(completionHandler: { (responsestr) in
            //                print(responsestr)
            //            })
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    completionHandler(JSON as AnyObject?, nil)
                }
                else {
                    print(response.result.error ?? "")
                    completionHandler(nil, response.result.error! as NSError)
                }
            }
    }
    
    //MARK:- POST
    func POSTAPICallWith(url:String, param:AnyObject, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("Request Parameters : ",param)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess") {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return;
        }
        
        print("Bearer Token :=>",UserManager.shared.token)
        
        let headers = ["Accept":"application/json","Authorization":UserManager.shared.token]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    if let message = (JSON as! NSDictionary).value(forKey: "message") as? String
                    {
                        if message == "Token is Expired"
                        {
                            UserManager.removeModel()
                            UserManager.getUserData()
                            UserManager.shared.userid = ""
                            UserManager.shared.token = ""
                            print(UserManager.shared.userid)
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            UIApplication.shared.windows.first?.rootViewController = redViewController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                        else{
                            completionHandler(JSON as AnyObject?, nil)
                        }
                    }
                    else{
                        completionHandler(JSON as AnyObject?, nil)
                    }
                }
                else {
                    print(response.result.error ?? "")
                    completionHandler(nil, response.result.error! as NSError)
                }
        }
    }
    
    //MARK:- Image Uploading
    func uploadImage(image:UIImage, url:String, param:NSDictionary, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return;
        }

        let headers = ["Content-Type":"multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            let data = image.jpegData(compressionQuality: 0.5)//UIImageJPEGRepresentation(image, 0.5)
            
            multipartFormData.append(data!, withName: "Profileimage", fileName: "profile_Placeholder.png", mimeType: "image/jpeg")
            //multipartFormData.append(data!, withName: "profile_image", mimeType: "image/png")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to: url,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if let JSON = response.result.value {
                                        completionHandler(JSON as AnyObject?, nil)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completionHandler(nil,encodingError as NSError?)
                            }
        })
    }
    
    func uploadImageRental(image:UIImage, url:String, param:NSDictionary, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return;
        }
        
        let headers = ["Content-Type":"multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            let data = image.jpegData(compressionQuality: 0.5)//UIImageJPEGRepresentation(image, 0.5)
            
            multipartFormData.append(data!, withName: "profileimage", fileName: "profile_Placeholder.png", mimeType: "image/jpeg")
            //multipartFormData.append(data!, withName: "profile_image", mimeType: "image/png")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to: url,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if let JSON = response.result.value {
                                        completionHandler(JSON as AnyObject?, nil)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completionHandler(nil,encodingError as NSError?)
                            }
        })
    }
    func uploadMultiImage(images:NSArray, url:String, param:NSDictionary, keyName:String, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess") {
            self.callNetworkAlert()
            //SVProgressHUD.dismiss()
            return;
        }
        
        let headers = ["Content-Type":"multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            let arrData = NSMutableArray()
            for image in images
            {
                let data = (image as! UIImage).jpegData(compressionQuality: 0.5)//UIImageJPEGRepresentation(image, 0.5)
                arrData.add(data!)
            }
            let dat = NSKeyedArchiver.archivedData(withRootObject: arrData)
            multipartFormData.append(dat, withName: keyName, fileName: "profile_Placeholder.png", mimeType: "image/jpeg")
            //multipartFormData.append(data!, withName: "profile_image", mimeType: "image/png")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to: url,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if let JSON = response.result.value {
                                        completionHandler(JSON as AnyObject?, nil)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completionHandler(nil,encodingError as NSError?)
                            }
        })
    }
   
    
    //MARK: Network Check
    func checkNetworkConnectivity()->String
    {
        let network:Reachability = Reachability()!;
        var networkValue:String = "" as String
        
        switch network.currentReachabilityStatus {
        case .notReachable:
            networkValue = "NoAccess";
            debugPrint("Network became unreachable")
            
        case .reachableViaWiFi:
            networkValue = "wifi";
            debugPrint("Network reachable through WiFi")
            
        case .reachableViaWWAN:
            networkValue = "Cellular Data";
            debugPrint("Network reachable through Cellular Data")
        }
        
        return networkValue;
    }
    
    func callNetworkAlert()
    {
        let alert = UIAlertView()
        alert.title = "No Network Found!"
        alert.message = "Please check your internet connection."
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    func ShowAlert(title: String, messsage: String)
    {
        let alert = UIAlertView()
        alert.title = title
        alert.message = messsage
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    func callBadNetworkAlert()
    {
        let alert = UIAlertView()
        alert.title = "Bad Internet Connection!"
        alert.message = "Please check your internet connection."
        alert.addButton(withTitle: "OK")
        alert.show()
    }
}



