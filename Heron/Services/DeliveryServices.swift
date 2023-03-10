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
        self.getListUserAddress { _, _ in }
    }
    
    func cleanData() {
        self.listUserAddress.accept([])
    }

    func getListUserAddress(completion:@escaping (String?, Bool) -> Void) {
        guard _AppCoreData.userSession.value != nil else {return}
        
        let fullURLRequest = kGatewayDeliveryServicesURL+"/delivery-addresses/users/own"
        
        _ = _AppDataHandler.get(parameters: [:], fullURLRequest: fullURLRequest) { responseData in
            if let responseMessage = responseData.responseMessage {
                print("Got error messgae %@", responseMessage)
                completion(responseMessage, false)
                return
            } else {
                if let data = responseData.responseData?["data"] as? [[String:Any]] {
                    let listAddress = Mapper<ContactDataSource>().mapArray(JSONArray: data)
                    self.listUserAddress.accept(listAddress)
                    completion(nil, true)
                    
                    if let defaultAddress = listAddress.first(where: { contactDataSource in
                        contactDataSource.isDefault == true
                    }) {
                        
                        if _CheckoutServices.deliveryAddress.value == nil {
                            _CheckoutServices.deliveryAddress.accept(defaultAddress)
                        }
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
    
    func getShippingInfor(orderID: String, completion:@escaping (String?, OrderShippingData?) -> Void) {
        
        let fullURLRequest = kGatewayDeliveryServicesURL + "/shipments/orders/" + orderID
        _ = _AppDataHandler.get(parameters: nil, fullURLRequest: fullURLRequest) { responseData in
                        
            if responseData.responseCode == 400 {
                completion(responseData.responseMessage, nil)
                return
            } else if responseData.responseCode >= 500 {
                return
            } else {
                if let data = responseData.responseData?["data"] as? [String:Any] {
                    completion(responseData.responseMessage, Mapper<OrderShippingData>().map(JSON: data))
                }
            }
        }
    }

}
