//
//  ArticleParser.h
//  Footnotes
//
//  Created by Alan Scarpa on 7/10/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"

@interface ArticleParser : NSObject

+(void)saveArticleToCoreData:(NSString*)articleURL dataStore:(DataStore*)dataStore;

@end
