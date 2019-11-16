//
//	Item.swift

import Foundation

struct Item{

	var emailId : String!
	var firstName : String!
	var imageUrl : String!
	var lastName : String!


	init(fromDictionary dictionary: [String:Any]){
		emailId = dictionary["emailId"] as? String
		firstName = dictionary["firstName"] as? String
		imageUrl = dictionary["imageUrl"] as? String
		lastName = dictionary["lastName"] as? String
	}

}
