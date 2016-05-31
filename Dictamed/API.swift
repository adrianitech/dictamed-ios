//
//  API.swift
//  CMP10C
//
//  Created by Adrian Mateoaea on 04.05.2016.
//  Copyright © 2016 CMP10C. All rights reserved.
//

import UIKit

class API: NSObject {
    
    static let sharedInstance = API()
    
    func getTranscripts(callback: (GetTranscriptsAPISenderObject, APICommunicationLayerError?) -> ()) {
        let sender = GetTranscriptsAPISenderObject()
        APICommunicationLayer.request(sender) { (_, error) in callback(sender, error) }
    }
    
    func deleteTranscript(id: String, callback: (DeleteTranscriptsAPISenderObject, APICommunicationLayerError?) -> ()) {
        let sender = DeleteTranscriptsAPISenderObject(id: id)
        APICommunicationLayer.request(sender) { (_, error) in callback(sender, error) }
    }
    
    func transcribeAudio(file: NSURL, progress: (Double) -> (), callback: (TranscribeAudioAPISenderObject, APICommunicationLayerError?) -> ()) {
        let sender = TranscribeAudioAPISenderObject(file: file)
        APICommunicationLayer.uploadAndParseAsString(sender,
                                                     progress: { (_, p) in progress(p) },
                                                     callback: { (_, error) in callback(sender, error) })
    }
    
    func postTranscript(title: String, translation: String, callback: (PostTranscriptsAPISenderObject, APICommunicationLayerError?) -> ()) {
        let transcript = TranscriptAPIModel(title: title, translation: translation)
        let sender = PostTranscriptsAPISenderObject(transcript: transcript)
        APICommunicationLayer.request(sender) { (_, error) in callback(sender, error) }
    }
    
    func postAudio(id: String, file: NSURL, progress: (Double) -> (), callback: (PostAudioAPISenderObject, APICommunicationLayerError?) -> ()) {
        let sender = PostAudioAPISenderObject(id: id, file: file)
        APICommunicationLayer.upload(sender,
                                     progress: { (_, p) in progress(p) },
                                     callback: { (obj, error) in callback(sender, error) })
    }
    
}
