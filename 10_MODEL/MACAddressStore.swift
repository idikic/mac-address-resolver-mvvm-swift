//
//  MACAddressStore.swift
//  M.A.C.
//
//  Created by iki on 17/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

class MACAddressStore: NSObject {

  // MARK: Singleton
  // More about singleton patterns is Swift can be found here:
  // https://github.com/hpique/SwiftSingleton
  class var sharedStore : MACAddressStore {
    struct Singleton {
      static let instance = MACAddressStore()
    }
    return Singleton.instance
  }
  
  var _privateItems = [MACAddressItem]()
  var allItems: [MACAddressItem] {
    return _privateItems
  }

  // MARK: Lifecycle
  private override init() {
    super.init()
    let unarchivedItems : AnyObject! = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchivedPath)
    if unarchivedItems != nil {
      _privateItems = unarchivedItems as! Array<MACAddressItem>
    }
  }

  // MARK: Public Interface
  func createItem(macAddress: String!, completionHandler:(macAddressItem: MACAddressItem?) -> ()) {
    Downloader.downloadJSON(macAddress) {
      (parsedJSON) in
      println(parsedJSON)
      let item = MACAddressItem(macAddress: macAddress)
      item?.company = parsedJSON[0]["company"].stringValue
      item?.address1 = parsedJSON[0]["addressL1"].stringValue
      item?.address2 = parsedJSON[0]["addressL2"].stringValue
      item?.country = parsedJSON[0]["country"].stringValue
      self._privateItems.append(item!)
      completionHandler(macAddressItem: item)
    }
  }

  func removeItem(macAddressItem: MACAddressItem!) {
    for (index, element) in enumerate(_privateItems) {
      if element === macAddressItem {
        _privateItems.removeAtIndex(index)
      }
    }
  }

  func removeItemAt(index: Int) {
    _privateItems.removeAtIndex(index)
  }

  func saveChanges() -> Bool {
    let path = itemArchivedPath
    return NSKeyedArchiver.archiveRootObject(_privateItems, toFile: path)
  }

  // MARK: Internal Helpers
  // computed property
  private var itemArchivedPath: String {
    get {
      let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
          NSSearchPathDomainMask.UserDomainMask, true)
      let documentDirectory = documentDirectories[0] as! String
      return documentDirectory.stringByAppendingPathComponent("items.archive")
    }
  }

  // mock data
  func loadMockData() {
    var macAddressItem = MACAddressItem(macAddress: "00:11:00:22:33:44:00 - TEST")
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
    _privateItems.append(macAddressItem!)
  }

}
