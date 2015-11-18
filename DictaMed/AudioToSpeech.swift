//
//  AudioToSpeech.swift
//  DictaMed
//
//  Created by Adrian Mateoaea on 17.10.2015.
//  Copyright © 2015 Adrian Mateoaea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum AudioToSpeechLanguage: String {
  case Romană  = "ro-ro"
  case English = "en-us"
}

protocol AudioToSpeechDelegate {
  
  func didReceiveAudioTranscript(transcript: String?)
  
}

class AudioToSpeech {
  
  private let apiKey = "AIzaSyA3QauQzWiq8sNp-13WZVkv5MLHoehjkrM"
  
  private let rootUrl = "https://www.google.com/speech-api/v2/recognize?output=json&lang=%@&key=%@"
  
  var language = AudioToSpeechLanguage.Romană
  
  var delegate: AudioToSpeechDelegate?
  
  private var url: String {
    return String(format: self.rootUrl, self.language.rawValue, self.apiKey)
  }
  
  func sendAudio(file: NSURL) {
    Alamofire.upload(.POST, self.url, headers: ["Content-Type": "audio/l16; rate=16000;"], file: file)
      .responseString { (response) -> Void in
        var string = response.result.value
        if let index = response.result.value?.characters.indexOf("\n") {
          string = response.result.value?.substringFromIndex(index)
        }
        
        if let string = string, let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
          let json = JSON(data: data)
          let text = json["result", 0, "alternative", 0, "transcript"].string
          self.delegate?.didReceiveAudioTranscript(text)
        }
    }
  }
  
}
