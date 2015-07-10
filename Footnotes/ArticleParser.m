//
//  ArticleParser.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/10/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ArticleParser.h"
#import "Article.h"


@implementation ArticleParser

+(void)saveArticleToCoreData:(NSString*)articleURL dataStore:(DataStore*)dataStore{

    
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:articleURL]
                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                   timeoutInterval:10];

[request setHTTPMethod: @"GET"];


[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    if (!connectionError){
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSString *textToRead = [NSString stringWithFormat:@"%@", jsonArray[@"objects"][0][@"text"]];
        
        NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"objects"][0][@"title"]];
        
        NSMutableString *html = [NSMutableString stringWithFormat:@"<style>img {max-width: 100%%; width: auto; height: auto;}</style><h3>%@</h3>", title];
        
        [html appendFormat:@"%@", jsonArray[@"objects"][0][@"html"]];
        
        Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:dataStore.managedObjectContext];
        article.url = articleURL;
        article.html = html;
        article.title = title;
        article.textToRead = textToRead;
        [dataStore save];
        NSLog(@"Done saving");
        
        //    [self.webView loadHTMLString:html baseURL:nil];
        //    self.textToRead = textToRead;
        
    } else {
        // Somehow show alert?
        NSLog(@"Problem saving article.");
    }
    
    
}];
}
@end