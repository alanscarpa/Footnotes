//
//  Article.h
//  Footnotes
//
//  Created by Alan Scarpa on 7/12/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * html;
@property (nonatomic, retain) NSString * textToRead;
@property (nonatomic, retain) NSString * remainingTextToRead;
@property (nonatomic, retain) NSNumber * hasBegunReading;
@property (nonatomic, retain) NSDate * dateAdded;

@end
