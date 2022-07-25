//
//  DeliveryServices.swift
//  Heron
//
//  Created by Luu Luc on 30/05/2022.
//

import ObjectMapper
import RxRelay
import ObjectiveC

class DeliveryServices: NSObject {
    
    public static let sharedInstance = DeliveryServices()
    public var listUserAddress      = BehaviorRelay<[ContactDataSource]>(value: [])
    
    override init() {
        super.init()
        
        // reload user address
        self.getListUserAddress()
    }

    func getListUserAddress() {
                
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses/users/own"
        
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
            if let responseMessage = responseData.responseMessage {
                print("Got error messgae %@", responseMessage)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    let listAddress = Mapper<ContactDataSource>().mapArray(JSONArray: data)
                    self.listUserAddress.accept(listAddress)
                    
                    if let defaultAddress = listAddress.first(where: { contactDataSource in
                        contactDataSource.isDefault == true
                    }) {
                        _CheckoutServices.deliveryAddress.accept(defaultAddress)
                        _CheckoutServices.billingAddress.accept(defaultAddress)
                    }
                }
            }
        }
    }
    
    func createNewUserAddress(newContact: ContactDataSource, completion:@escaping (String?, Bool) -> Void) {
        
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses"
        
        _ = _AppDataHandler.post(parameters: newContact.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            if let responseMessage = responseData.responseMessage {
                print("Got error messgae %@", responseMessage)
                completion(responseMessage, false)
            } else if responseData.responseCode == 201 {
                // created
                completion(nil, true)
            }
        }
    }
    
    func updateUserAddress(newContact: ContactDataSource, completion:@escaping (String?, Bool) -> Void) {
        
        let contactID = newContact.id
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses/" + contactID
        
        _ = _AppDataHandler.patch(parameters: newContact.toJSON(), fullURLRequest: fullURLRequest) { responseData in
            if let responseMessage = responseData.responseMessage {
                completion(responseMessage, false)
                return
            } else if responseData.responseCode == 204 {
                // created
                completion(nil, true)
            } else {
                completion(responseData.responseMessage, false)
            }
        }
    }

}
