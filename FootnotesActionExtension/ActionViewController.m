//
//  ActionViewController.m
//  FootnotesActionExtension
//
//  Created by Alan Scarpa on 7/7/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"yo");
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                
                __weak ActionViewController *sself = self;
                
                [itemProvider loadItemForTypeIdentifier: (NSString *) kUTTypePropertyList
                                                options: 0
                                      completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
                                          
                                          if (item != nil) {
                                              
                                              NSDictionary *resultDict = (NSDictionary *) item;
                                              
                                              NSLog(@"%@", resultDict[NSExtensionJavaScriptPreprocessingResultsKey][@"content"]);
                                              
                                          }
                                          
                                      }];
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
