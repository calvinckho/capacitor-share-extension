//
//  ShareViewController.swift
//  testShareExtension
//
//  Created by Jonathan on 3/25/19.
//

import UIKit
import Social
import MobileCoreServices
import Foundation.NSURLSession
class ShareViewController: SLComposeServiceViewController {
    private var urlString: String?
    private var textString: String?
    public var item: SLComposeSheetConfigurationItem!
    private var selectedConversation: Conversation?
    private var auth : String?
    private var userConversations = [Conversation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedConversation = nil
        let contentsOfKeychain = retreiveFromKeyChain()
        
        
        addConversationData(contentsOfKeychain: contentsOfKeychain)
        
        
        //make sure data given is URL or text
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        let contentTypeText = kUTTypeText as String
        
        for attachment in extensionItem.attachments as! [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
                    let text = results as! String
                    self.textString = text
                })
            }
            if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    let url = results as! URL?
                    self.urlString = url!.absoluteString
                })
            }

        }
        guard let text = textView.text else {return}
        
    }
    
    
    
    
    
    //make sure content given is valid
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        if urlString != nil || textString != nil {
            if !contentText.isEmpty {
                return true
            }
        }
        print("reaches valid content")
        return true
    }

    
    
    
    
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        var composedMessage: Any? = nil
        var groupID: Any? = nil // previously used for socketData
        var jsonServerData: Any? = nil
        //var jsonSocketData: Any? = nil
        
    
        composedMessage = (textString ?? "") + (urlString ?? "")
        if selectedConversation == nil {
            //TODO: popup a UIAlertController if no conversation is selected
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
//        previously used for socketData
//        else if selectedConversation?.type == "group"{
//            groupID = selectedConversation?.groupId
//        }
        

        
        //initialize the serverData
        let serverData = [
                            "composedMessage": composedMessage,
                            "sendSocketIO": true
            ] as [String : Any?]
        
        do{
            //convert serverData to JSON
            jsonServerData = try JSONSerialization.data(withJSONObject: serverData, options: [])
            // post message
            var request = URLRequest(url: URL(string: "https://server.restvo.com/api/chat/"+(selectedConversation?.convId)!)!)
            
            
            
            request.httpMethod = "POST"
            request.setValue(auth, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonServerData as! Data
            URLSession.shared.dataTask(with: request) {data, response, err in
                print("Entered the completionHandler")
                }.resume()
        }
        catch{
            print("error converting data to JSON object")
        }

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    
    
    
    
    // adds deck on bottom of share extension
    override func configurationItems() -> [Any]! {
        //configures deck @ bottom of share extension
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Selected Conversation"
 
            deck.tapHandler = {
                let vc = ShareSelectViewController()
                vc.delegate = self
                vc.conversationList = self.userConversations
                self.pushConfigurationViewController(vc)
            }


            deck.value = selectedConversation?.name
            
            return [deck]
        }
        return []
    }
    // previously used for socketData
    private func getFormattedDate() -> String{
        //get the date and format it
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        //remove the quotes around 'Z' if using non UTC time
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let formattedDate = dateFormatter.string(from: date as Date)
        return formattedDate
    }

    private func retreiveFromKeyChain()->String{
        //retrieve from keychain
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: "token",
                                       kSecReturnData as String: kCFBooleanTrue,
                                       kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var dataTypeRef :AnyObject? = nil
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(getquery as CFDictionary, &dataTypeRef)
        
        var contentsOfKeychain: String?
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
            else{
                print("Error converting data. Status code \(status)")
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        //print the contents of the keychain
        return (contentsOfKeychain!)
        
    }
    private func addConversationData(contentsOfKeychain: String){
        //RESTFull HTTP get request
        //gets conversations and adds them to a list
        auth = contentsOfKeychain
        
        let urlPath = "https://server.restvo.com/api/chat"
        let url: NSURL = NSURL(string: urlPath)!
        var request = URLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            self.parseToJSON(responseData: responseData)
            
        }
        task.resume()
        
    }
    private func parseToJSON(responseData: Data){
        var name: Any?
        // parse the result as JSON, since that's what the API provides
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:responseData, options: [])
            //convert json to dictionary
            if let responseDictionary = jsonResponse as? [[String: Any]] {
                //for each conversation
                for x in 0...responseDictionary.count-1 {
                    //create a new conversation object to store info
                    let tempConversation = Conversation()
                    if let indivResponse = responseDictionary[x] as? [String: Any] {
                        let convData = indivResponse["conversation"] as? [String: Any]
                        //get the conversation type
                        //group means group connect means direct message
                        let type = convData?["type"] as? String
                        if type == "group"{
                            let group = convData?["group"] as? [String:Any]
                            name = group?["name"] as? String
                            tempConversation.type = "group"
                            tempConversation.groupId = group?["_id"] as? String
                        }
                        else{
                            name = (indivResponse["data"] as? [String:Any])?["name"] as? String
                            tempConversation.type = "connect"
                            tempConversation.groupId = nil
                        }
                        tempConversation.convId = convData?["_id"] as? String
                    }
                    // if name does not exist
                    if(name == nil){
                        name = "unsupported conversation version"
                    }
                    //add converstaion to list
                    tempConversation.name = name as? String
                    self.userConversations.append(tempConversation)
                    
                }
            }
            else{
                print("error converting data to dictionary")
            }
        }
        catch  {
            print("error trying to convert data to JSON")
            return
        }
    }
    
    

}
extension ShareViewController: ShareSelectViewControllerDelegate {
    func sendingViewController(sentItem: Conversation) {
        self.selectedConversation = sentItem
        reloadConfigurationItems()
        self.popConfigurationViewController()
    }
}
