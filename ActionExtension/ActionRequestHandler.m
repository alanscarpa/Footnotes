//
//  ActionRequestHandler.m
//  ActionExtension
//
//  Created by Alan Scarpa on 7/10/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ActionRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DataStore.h"
#import "Article.h"
#import "ArticleParser.h"

@interface ActionRequestHandler ()

@property (nonatomic, strong) NSExtensionContext *extensionContext;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    
    self.dataStore = [DataStore sharedDataStore];
    
    // Do not call super in an Action extension with no user interface
    self.extensionContext = context;
    
    BOOL found = NO;
    
    // Find the item containing the results from the JavaScript preprocessing.
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self itemLoadCompletedWithPreprocessingResults:dictionary[NSExtensionJavaScriptPreprocessingResultsKey]];
                    }];
                }];
                found = YES;
            }
            break;
        }
        if (found) {
            break;
        }
    }
    
    if (!found) {
        // We did not find anything
        [self doneWithResults:nil];
    }
}

- (void)itemLoadCompletedWithPreprocessingResults:(NSDictionary *)javaScriptPreprocessingResults {
    // Here, do something, potentially asynchronously, with the preprocessing
    // results.
    
    // In this very simple example, the JavaScript will have passed us the
    // current url
    NSString *urlString = javaScriptPreprocessingResults[@"baseURI"];
    NSLog(@"%@", urlString);
    [self saveArticleToCoreData:urlString];
    
    // NSLog(@"%@", urlString);
    
    
    
    //    NSFetchRequest *requestArticles = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    //
    //    NSSortDescriptor *sortArticlesByName = [NSSortDescriptor sortDescriptorWithKey:@"url" ascending:YES];
    //    requestArticles.sortDescriptors = @[sortArticlesByName];
    //    NSArray *listOfArticleURLs = [self.dataStore.managedObjectContext executeFetchRequest:requestArticles error:nil];
    //
    //    for (Article *article in listOfArticleURLs){
    //        NSLog(@"%@", article.url);
    //    }
    
}


-(void)saveArticleToCoreData:(NSString*)articleURL {
    
    articleURL = [articleURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *escapedURL = [@"http://api.diffbot.com/v3/article?token=f573d590d93ff414652a15c5042141f0&url=" stringByAppendingString:articleURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data){
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", jsonArray);
            
            NSString *textToRead = [NSString stringWithFormat:@"%@", jsonArray[@"objects"][0][@"text"]];
            
            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"objects"][0][@"title"]];
            
            NSMutableString *html = [NSMutableString stringWithFormat:@"<style>img {max-width: 100%%; width: auto; height: auto;}</style><h3>%@</h3>", title];
            
            [html appendFormat:@"%@", jsonArray[@"objects"][0][@"html"]];
            
            Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.dataStore.managedObjectContext];
            article.url = articleURL;
            article.html = (NSString*)html;
            article.title = title;
            article.textToRead = textToRead;
            [self.dataStore save];
            NSLog(@"Done saving");
            
            //    [self.webView loadHTMLString:html baseURL:nil];
            //    self.textToRead = textToRead;
            
            
            // Somehow show alert?
            //  NSLog(@"Problem saving article.");
        } else {
            NSLog(@"%@", response);
            NSLog(@"%@", connectionError);
        }
        
       
        
        
    }];
}



- (void)doneWithResults:(NSDictionary *)resultsForJavaScriptFinalize {
    if (resultsForJavaScriptFinalize) {
        // Construct an NSExtensionItem of the appropriate type to return our
        // results dictionary in.
        
        // These will be used as the arguments to the JavaScript finalize()
        // method.
        
        NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize };
        
        NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];
        
        NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
        resultsItem.attachments = @[resultsProvider];
        
        // Signal that we're complete, returning our results.
        [self.extensionContext completeRequestReturningItems:@[resultsItem] completionHandler:nil];
    } else {
        // We still need to signal that we're done even if we have nothing to
        // pass back.
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
    
    // Don't hold on to this after we finished with it.
    self.extensionContext = nil;
}

@end
