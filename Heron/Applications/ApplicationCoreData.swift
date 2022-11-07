//
//  ApplicationCoreData.swift
//  Heron
//
//  Created by Luu Lucas on 9/23/20.
//  Copyright © 2020 Luu Lucas. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import ObjectMapper
import RxRelay
import RxSwift

@_exported import BugfenderSDK
class ApplicationCoreData: NSObject {
    
    public static let sharedInstance    = ApplicationCoreData()
    
    public var userSession              = BehaviorRelay<SessionDataSource?>(value: nil)
    public var userDataSource           = BehaviorRelay<UserDataSource?>(value: nil)
    public var listsavedProducts        : [ProductDataSource] = []
    private let disposeBag              = DisposeBag()
    
    private var timerRefeshToken: Timer?
    
    // MARK: - Initial
    override init() {
        super.init()
        self.initSync()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            self.bindingData()
        }
    }
    
    private func bindingData() {
        self.userSession
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.syncDown()
            }
            .disposed(by: disposeBag)
        
        self.userDataSource
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.syncDown()
            }
            .disposed(by: disposeBag)
    }
    
    func signOut() {
        self.userSession.accept(nil)
        self.userDataSource.accept(nil)
        _EHProfileServices.cleanData()
        _BookingServices.cleanData()
        _DeliveryServices.cleanData()
        _CartServices.cleanData()
        _CheckoutServices.cleanData()
        _OrderServices.cleanData()
        
        // Stop Refresh token
        self.timerRefeshToken?.invalidate()
        self.timerRefeshToken = nil
        
        self.syncDown()
    }
    
    // MARK: - Sync to local
    private func initSync() {
        // Sync userSession
        if UserDefaults.standard.object(forKey: kUserSessionDataSource) is String {
            if let data = UserDefaults.standard.object(forKey: kUserSessionDataSource) as? String {
                let sessionData = SessionDataSource.init(JSONString: data)
                if sessionData != nil {
                    self.userSession.accept(sessionData)
                } else {
                    UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
                }
            }
        } else {
            UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
        }
        
        // sync userDataSource
        if UserDefaults.standard.object(forKey: kUserProfileDataSource) is String {
            if let data = UserDefaults.standard.object(forKey: kUserProfileDataSource) as? String {
                let userData = UserDataSource.init(JSONString: data)
                if userData != nil {
                    self.userDataSource.accept(userData)
                } else {
                    UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
                }
            }
        } else {
            UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
        }
        
        // sync saved products
        self.loadCachedProducts()
    }
    
    private func syncDown() {
        // Sync SessionDataSource
        if self.userSession.value == nil {
            UserDefaults.standard.removeObject(forKey: kUserSessionDataSource)
        } else {
            let data = self.userSession.value?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserSessionDataSource)
        }
        
        // Sync UserDataSource
        if self.userDataSource.value == nil {
            UserDefaults.standard.removeObject(forKey: kUserProfileDataSource)
        } else {
            let data = self.userDataSource.value?.toJSONString()
            UserDefaults.standard.setValue(data, forKey: kUserProfileDataSource)
        }
        
        if let userEmail = self.userDataSource.value?.userEmail {
            Bugfender.setDeviceString(userEmail, forKey: "user_Iden")
        }
    }

    // MARK: - Core Data stack and saving
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Heron")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Cached products
extension ApplicationCoreData {
    func cachedProducts(_ listProducts: [ProductDataSource]) {
        
        self.listsavedProducts = listProducts
        self.deleteAllData()
                
        DispatchQueue.main.async { [unowned self] in
            for product in listProducts {
                let commit = LocalProductDataSource(context: self.persistentContainer.viewContext)
                commit.id = product.id
                commit.targetId = product.targetId
                commit.code = product.code
                commit.name = product.name
                commit.shortDesc = product.shortDesc
                for desc in product.desc {
                    let dec = LocalContentDescription(context: self.persistentContainer.viewContext)
                    dec.content = desc.content
                    dec.title = desc.title
                    dec.visibility = desc.visibility
                    dec.product = commit
                }
                commit.currency = product.currency
                commit.finalPrice = Int64(product.finalPrice)
                commit.currency = product.currency
                commit.thumbnailUrl = product.thumbnailUrl
                for media in product.media {
                    let localMedia = LocalProductMediaDataSource(context: self.persistentContainer.viewContext)
                    localMedia.type = media.type
                    localMedia.valueA = media.value
                    localMedia.sortOrder = Int64(media.sortOrder)
                    localMedia.product = commit
                }
                commit.available = product.available
                commit.featureType = product.featureType.rawValue
                if let unit = product.unit {
                    let localUnit = LocalProductUnit(context: self.persistentContainer.viewContext)
                    localUnit.id = unit.id
                    localUnit.name = unit.name
                    localUnit.product = commit
                }
                if let brand = product.brand {
                    let localBrand = LocalProductBrand(context: self.persistentContainer.viewContext)
                    localBrand.id = brand.id
                    localBrand.name = brand.name
                    localBrand.product = commit
                }
                commit.createdAt = Int64(product.createdAt)
                commit.type = product.type.rawValue
                for configurableOption in product.configurableOptions {
                    let localConfig = LocalConfigurableOption(context: self.persistentContainer.viewContext)
                    localConfig.code = configurableOption.code
                    localConfig.label = configurableOption.label
                    localConfig.values = configurableOption.values.joined(separator: "[-Lucas-]")
                    localConfig.product = commit
                }
                for attributeValue in product.attributeValues {
                    let localAttributeValue = LocalProductAttributeValue(context: self.persistentContainer.viewContext)
                    localAttributeValue.id = attributeValue.id
                    localAttributeValue.attributeCode = attributeValue.attributeCode
                    localAttributeValue.valueA = attributeValue.value
                    let localAttribute = LocalProductAttribute(context: self.persistentContainer.viewContext)
                    localAttribute.label = attributeValue.attribute?.label ?? ""
                    localAttribute.sortOrder = Int64(attributeValue.attribute?.sortOrder ?? 0)
                    localAttribute.relationship = localAttributeValue
                    localAttributeValue.product = commit
                }
                commit.discountPercent = product.discountPercent
                commit.quantity = Int64(product.quantity)
                commit.customRegularPrice = product.customRegularPrice
                commit.customFinalPrice = product.customFinalPrice
            }
            
            self.saveContext()
        }
    }
    
    func loadCachedProducts() {
        let fetchRequest: NSFetchRequest<LocalProductDataSource> = (LocalProductDataSource).fetchRequest()
        
        do {
            let commits = try self.persistentContainer.viewContext.fetch(fetchRequest)
            print("Got \(commits.count) commits")
            
            var newSet : Set<ProductDataSource> = []
            for localProduct in commits {
                let newProduct = ProductDataSource.init(JSONString: "{}")!
                newProduct.id = localProduct.id ?? ""
                newProduct.targetId = localProduct.targetId ?? ""
                newProduct.code = localProduct.code ?? ""
                newProduct.name = localProduct.name ?? ""
                newProduct.shortDesc = localProduct.shortDesc ?? ""
                for decs in (localProduct.desc?.allObjects ?? []) {
                    var newDec = ContentDescription.init(JSONString: "{}")!
                    newDec.title = (decs as AnyObject).title ?? ""
                    newDec.visibility = (decs as AnyObject).visibility ?? false
                    newDec.content = (decs as AnyObject).content ?? ""
                    newProduct.desc.append(newDec)
                }
                newProduct.currency = localProduct.currency
                newProduct.finalPrice = Int(localProduct.finalPrice)
                newProduct.currency = localProduct.currency
                newProduct.thumbnailUrl = localProduct.thumbnailUrl
                for media in (localProduct.media?.allObjects ?? []) {
                    let newMedia = ProductMediaDataSource.init(JSONString: "{}")!
                    newMedia.type = (media as AnyObject).type ?? ""
                    newMedia.value = (media as AnyObject).value ?? ""
                    newMedia.sortOrder = Int((media as AnyObject).sortOrder ?? 0)
                    newProduct.media.append(newMedia)
                }
                newProduct.available = localProduct.available
                newProduct.featureType = ProductFeatureType(rawValue: localProduct.featureType ?? "") ?? .ecom
                if let unit = localProduct.unit {
                    var newUnit = ProductUnit.init(JSONString: "{}")!
                    newUnit.id = unit.id ?? ""
                    newUnit.name = unit.name ?? ""
                    newProduct.unit = newUnit
                }
                if let brand = localProduct.brand {
                    var newBrand = ProductBrand.init(JSONString: "{}")!
                    newBrand.id = brand.id ?? ""
                    newBrand.name = brand.name ?? ""
                    newProduct.brand = newBrand
                }
                newProduct.createdAt = Int(localProduct.createdAt)
                newProduct.type = ProductType(rawValue: localProduct.type ?? "") ?? .simple
                for configuration in (localProduct.configurableOptions?.allObjects ?? []) {
                    var newConfig = ConfigurableOption.init(JSONString: "{}")!
                    newConfig.code = (configuration as AnyObject).code ?? ""
                    newConfig.values = ((configuration as AnyObject).values ?? "")?.components(separatedBy: "[-Lucas-]") ?? []
                    newConfig.label = (configuration as AnyObject).label ?? ""
                    newProduct.configurableOptions.append(newConfig)
                }
                for attributeValue in (localProduct.attributeValues?.allObjects ?? []) {
                    var newAttributeValue = ProductAttributeValue.init(JSON: [:])!
                    newAttributeValue.id = (attributeValue as AnyObject).id ?? ""
                    newAttributeValue.attributeCode = (attributeValue as AnyObject).attributeCode ?? ""
                    newAttributeValue.value = (attributeValue as AnyObject).valueA ?? ""
                    newProduct.attributeValues.append(newAttributeValue)
                }
                newProduct.discountPercent = localProduct.discountPercent
                newProduct.quantity = Int(localProduct.quantity)
                newProduct.customRegularPrice = localProduct.customRegularPrice
                newProduct.customFinalPrice = localProduct.customFinalPrice
                
                newSet.insert(newProduct)
            }
            self.listsavedProducts = newSet.sorted(by: > )
        } catch {
            print("Fetch failed")
        }
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalProductDataSource")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                self.persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in LocalProductDataSource error :", error)
        }
    }
}
