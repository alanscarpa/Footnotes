//
//  ArticleViewController.h
//  Footnotes
//
//  Created by Alan Scarpa on 7/2/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "Article.h"

@interface ArticleViewController : UIViewController
@property (nonatomic, strong) Article *article;
@end
