//
//  ComplicationController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 15.06.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        var template: CLKComplicationTemplate? = nil
        
        switch complication.family {
        case .ModularSmall:
            let smallTemplate = CLKComplicationTemplateModularSmallSimpleImage()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        case .UtilitarianSmall:
            let smallTemplate = CLKComplicationTemplateUtilitarianSmallSquare()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        case .CircularSmall:
            let smallTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        default:
            break
        }
        
        handler(template)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(CLKComplicationPrivacyBehavior.ShowOnLockScreen)
    }
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {
        var template: CLKComplicationTemplate? = nil
        
        switch complication.family {
        case .ModularSmall:
            let smallTemplate = CLKComplicationTemplateModularSmallSimpleImage()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        case .UtilitarianSmall:
            let smallTemplate = CLKComplicationTemplateUtilitarianSmallSquare()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        case .CircularSmall:
            let smallTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            smallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "ic_complication")!)
            template = smallTemplate
        default:
            break
        }
        
        if let template = template {
            handler(CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template))
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
        handler([])
    }
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([CLKComplicationTimeTravelDirections.None])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
}
