<p align="center"><a href="https://paysky.io/" target="_blank"><img width="440" src="https://paysky.io/wp-content/uploads/2021/05/PaySky-logo.svg"></a></p>

# PaySky PayButton SDK
The PayButton helps make the integration of card acceptance into your app easy.

You simply provide the merchant information you receieve from PaySky to the payment SDK. The PayButton displays a ready-made view that guides the merchant through the payment process and shows a Summary screen at the end of the transaction.

### Getting Started

### Prerequisites
This project uses cocoapods for dependencies management. If you don't have cocoapods installed in your machine, or are using older version of cocoapods, you can install it in terminal by running command ```sudo gem install cocoapods```. For more information go to https://cocoapods.org/

1. Download CocoaPods on your machine if you don't already have it
```
sudo gem install cocoapods
```

2. Create a Podfile to your project.
```
pod init
```

3. Install third-party libraries using `pod`
```
pod install
```

## 💻 Installation

1. Add the pod to your Podfile:
```
pod 'PayButton'
```

2. Open the terminal and run
```
pod deintegrate
pod clean
pod install
```

## 🚀 Deployment
1. Before deploying your project live, you should get a merchant ID, terminal ID and Secure Hash Key from our company.
2. You should keep your merchant ID and terminal ID secured in your project, encrypt them before save them in project.

## 🛠 How to use
In order to use the SDK you should get a Merchant ID, a Terminal ID, and a Secure Hash Key from PaySky company.​

### 👉 Import
In the class you want to initiate the payment from, you should import the framework
```swift
import PayButton
```

After the import, create a new instance from PayButton and initialize the following data in the PayButton instance.
1) Merchant id
2) Terminal id
3) Secure hash key
4) Payment amount
5) Currency code (https://www.iban.com/currency-codes)
6) Transaction reference number [Optional] (Generate unique 16-digits number)
7) If the user is not subscribed, you will need to pass the customer's mobile number or email.
   Otherwise, the user is subscribed so you will pass by the customer ID.


If the merchant is *Not Subscribed*, and the channel selected is *Mobile Number*:-
```swift
let paymentViewController = PaymentViewController(merchantId: "merchantId",
                                                  terminalId: "terminalId",
                                                  amount: Double("amount"),
                                                  currencyCode: Int("currencyCode"),
                                                  secureHashKey: "secure_hash_key",
                                                  trnxRefNumber: "reference_number" ?? "",
                                                  customerMobile: "xxxxxxxxxx",
                                                  isProduction: true)    // for testing environment use false
paymentViewController.delegate = self       // Payment Delegate
paymentViewController.pushViewController()
```

If the merchant is *Not Subscribed*, and the channel selected is *Email*:-
```swift
let paymentViewController = PaymentViewController(merchantId: "merchantId",
                                                  terminalId: "terminalId",
                                                  amount: Double("amount"),
                                                  currencyCode: Int("currencyCode"),
                                                  secureHashKey: "secure_hash_key",
                                                  trnxRefNumber: "reference_number" ?? "",
                                                  customerEmail: "joe@name.com",
                                                  isProduction: true)    // for testing environment use false
paymentViewController.delegate = self   // Payment Delegate
paymentViewController.pushViewController()
```

If the merchant is *Subscribed*:-
```swift
let paymentViewController = PaymentViewController(merchantId: "merchantId",
                                                  terminalId: "terminalId",
                                                  amount: Double("amount"),
                                                  currencyCode: Int("currencyCode"),
                                                  secureHashKey: "secure_hash_key",
                                                  trnxRefNumber: "reference_number" ?? "",
                                                  customerId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                                                  isProduction: true)     // for testing environment use false
paymentViewController.delegate = self   // Payment Delegate
paymentViewController.pushViewController()
```

In order to create transaction callback in delegate PaymentDelegate, implement delegate on your ViewController.

```swift 
class ViewController: UIViewController, PayButtonDelegate {
    func finishedSdkPayment(_ response: PayByCardReponse) {
        if response.success == true {
            debugPrint("-------- Customer ID --------")
            debugPrint(response.tokenCustomerId ?? "")
            
            UIPasteboard.general.string = response.tokenCustomerId
            UIApplication.topViewController()?.view.makeToast("Transaction completed successfully and customer Id copied to clipboard")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.navigationController != nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            debugPrint("response.message")
            UIApplication.topViewController()?.view.makeToast(response.message)
        }
    }
}
```

## 🛠️ Built With
* [Alamofire](https://github.com/Alamofire/Alamofire)  
* [PayCardsRecognizer](https://cocoapods.org/pods/PayCardsRecognizer)

## ✍️ Authors
**PaySky Company** - (https://www.paysky.io)

## 👀 Sample Project
**https://github.com/payskyCompany/PayButtonIOSExample.git**
