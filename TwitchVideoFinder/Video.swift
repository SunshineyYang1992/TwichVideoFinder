//
//  Video.swift
//  TwitchVideoFinder
//
//  Created by Sunshine Yang on 11/21/15.
//  Copyright © 2015 SunshineYang. All rights reserved.
//

import Foundation

// Keep track of video information 

class Video {
	
	var title: String
	var description:String
	var views: String
	var channel: String
	var previewImageURL:String
	var thumbnail:String
	var length: String
	var url: String
	
	init(title: String, description:String, views:String, channel:String,previewImageURL:String,thumbnail:String, length:String, url:String) {
		self.title = title
		self.description = description
		self.views = views
		self.channel = channel
		self.previewImageURL = previewImageURL
		self.thumbnail = thumbnail
		self.length = length
		self.url = url
	}
	
}