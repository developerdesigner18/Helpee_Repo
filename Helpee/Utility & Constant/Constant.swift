//
//  Constant.swift
//  GoPot
//
//  Created by macbook on 23/11/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH   == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH   == 1366.0
    static let IS_IPHONE_XSMAX      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 2688.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 1792.0
}

let BASE_URL = "http://64.227.24.156/api/"

let REGISTER = "register"
let LOGIN = "login"
let SOCIAL_LOGIN = "sociallogin"
let LOGOUT = "logout"
let DELETE_ACC = "deleteacc"
let SHOW_DATA = "showdata"
let UPDATE_DATA = "updatedata"
let GET_LOCATION = "getlocation"
let VERIFY_CODE = "verifycode"
let CREATE_ALERT = "createalert"
let GET_INCEDENTS = "getincidents"
let SAVE_TOKEN = "savetoken"
let LANGUAGE = "language"
let LAT_LONG = "callback"
let GET_EMERGENCY = "getnumbers"
