# reach-ios-sample

## Overview
This repository contains source code to demonstrate the basic use of Sixgill Reach SDK. 
You can find the complete SDK documentation [here](https://docs.sixgill.com/guides/sdks/ios-sdk)

## Implementation details
Reach SDK requires some permissions in order to work properly. Skipping some of the permissions will disable the related feature, for example if you skip the location permission then SDK won't be able to collect the location of the user.
The permissions are added in the [Info.plist](https://github.com/sixgill/reach-ios-sample/blob/master/SampleApp/Info.plist)

Once the permission are added in the SDK, it's time to ask the user to grant those required permissions. See [ViewController.swift](https://github.com/sixgill/reach-ios-sample/blob/6ae4ebbeadebdef26129d103097d147e442302bd/SampleApp/ViewController.swift#L121)
```swift
private func requestForPermissions() {
    // Location Permission
    SGSDK.requestAlwaysPermission()
        
    // Motion Activity Permission
    let motionActivityManager = CMMotionActivityManager()
    motionActivityManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { (activities, error) in
            
    }
}
```

To start the SDK we need to pass some of the basic information:
- API Key
- Aliases (can be unique phone number)

Additionally you can turn off the functionality of the SDK to stop sending the events to Sixgill server (by default this is ON).
```swift
let config = SGSDKConfigManager();
config.shouldSendDataToServer = false;
```

Finally to start the SDK you can call the `startWithAPIKey` method of the SDK
See [ViewController.swift](https://github.com/sixgill/reach-ios-sample/blob/6ae4ebbeadebdef26129d103097d147e442302bd/SampleApp/ViewController.swift#L87)
```swift
let config = SGSDKConfigManager();
// Pick selected endpoint from dropdown
config.ingressURL = Constants.urls[dropDownPicker.selectedRow(inComponent: 0)]
config.shouldSendDataToServer = sendToServerSwitch.isOn

var dict = ["phone": phone_number];
// some additional information can be added to aliases as well
dict["organization"] = "sixgill"
config.aliases = dict as? NSMutableDictionary;


SGSDK.sharedInstance()?.start(withAPIKey: apiKey, andConfig: config, andSuccessHandler: {
  
  // Once the SDK is initialized, you need to enable the SDK to start collecting the events.
  SGSDK.enable(successHandler: {
          DispatchQueue.main.async {
              self.modifyUI(isRequestSent: false)
              UserDefaults.standard.set(true, forKey: Constants.IS_SDK_RUNNING)
              self.showEventsViewController() // move to detail screen to receive events. 
              return
          }
      }, andFailureHandler: { (failureMsg) in
          DispatchQueue.main.async {
              self.modifyUI(isRequestSent: false)
              self.view.makeToast(failureMsg)
          }
      })
  }) { (failureMsg) in
      DispatchQueue.main.async {
          self.modifyUI(isRequestSent: false)
          self.view.makeToast(failureMsg)
      }
}
```

Once the SDK is enabled you can register to receive events, extend the protocol `SensorUpdateDelegate` (see [EventsTableViewController.swift])(https://github.com/sixgill/reach-ios-sample/blob/6ae4ebbeadebdef26129d103097d147e442302bd/SampleApp/EventsTableViewController.swift#L12) and register
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    SGSDK.register(forSensorUpdates: self)
}
```
See [EventsTableViewController.swift](https://github.com/sixgill/reach-ios-sample/blob/6ae4ebbeadebdef26129d103097d147e442302bd/SampleApp/EventsTableViewController.swift#L50)
```swift
func sensorUpdateSent(withData sensorData: Event!) {
    events.insert(sensorData, at: 0)
    eventsTableView.reloadData()
}
```
Do remember to unregister the listener to prevent memory leaks
```swift
SGSDK.register(forSensorUpdates: nil)
```

Finally to stop the SDK, you need to call `disable` method of SDK
```swift
SGSDK.disable()
```

Reach SDK also provides you functionality to generate event on demand. 
```swift
// forceSensorUpdate will generate the event on demand, any on demand generated event has toq be received in the SensorUpdateDelegate, described above in this readme
SGSDK.forceSensorUpdate()
```

If any permission is missing, Reach SDK will generate error code and error message in the event itself. To check the errors, you can call `event.errorArray.count` method and `event.errorArray` method
```swift
Event e = events[indexPath.row]
 if(e.errorArray.count > 0){
    let errors = e.errorArray as NSArray as! [SixgillSDK.Error]
    let errorCode = errors[0].errorCode
    let errorMessage = errors[0].errorMessage
}
```
