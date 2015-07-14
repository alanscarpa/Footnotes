//
//  ArticleParser.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/10/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ArticleParser.h"
#import "Article.h"
#import <UIKit/UIKit.h>


@implementation ArticleParser



//+ (NSString*)stripCSS:(NSString*)htmlStringToStrip {
//    NSString *s = htmlStringToStrip;
//    NSUInteger len = [s length];
//    unichar buffer[len+1];
//    BOOL inTheZone = NO;
//    BOOL outsideTags = NO;
//    
//    NSMutableString *strippedDownHtml = [[NSMutableString alloc]init];
//    
//    [s getCharacters:buffer range:NSMakeRange(0, len)];
//    
//    for(int i = 0; i < len; i++) {
//        
//        if (buffer[i] == ' '){
//            if (inTheZone){
//                inTheZone = NO;
//            } else if (outsideTags) {
//                // add char to nsmutable string
//                [strippedDownHtml appendString:[NSString stringWithFormat:@"%C", buffer[i]]];
//
//            }
//            
//          //  NSLog(@"Found a space, don't do anything");
//        } else if (buffer[i] == '<'){
//            inTheZone = YES;
//            outsideTags = NO;
//            // add char to nsmutable string
//            [strippedDownHtml appendString:[NSString stringWithFormat:@"%C", buffer[i]]];
//
//            
//        } else if (buffer[i] == '>'){
//            inTheZone = NO;
//            outsideTags = YES;
//            // add char to nsmutable string
//            [strippedDownHtml appendString:[NSString stringWithFormat:@"%C", buffer[i]]];
//
//            
//        } else {
//            if (inTheZone || outsideTags){
//               // add char to nsmutablestring
//                [strippedDownHtml appendString:[NSString stringWithFormat:@"%C", buffer[i]]];
//
//            } else {
//                
//            }
//        }
//    }
//    NSLog(@"Done stripping");
//    return strippedDownHtml;
//}




+ (NSString*)stringByStrippingHTML:(NSString*)stringToStrip {
    NSRange r;
    NSString *s = stringToStrip;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

// READABILITY
+(void)saveArticleToCoreData:(NSString*)articleURL dataStore:(DataStore*)dataStore{
    
    articleURL = [articleURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *escapedURL = [@"http://readability.com/api/content/v1/parser?token=781e1dfed669b731e19f697ad977c3b8a0304d9c&url=" stringByAppendingString:articleURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data){
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //NSLog(@"%@", jsonArray);
            //NSLog(@"%@", jsonArray[@"content"]);
            
            NSString *textToRead = [NSString stringWithFormat:@".  %@", jsonArray[@"content"]];
            
            
            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"title"]];
            textToRead = [title stringByAppendingString:textToRead];
            textToRead = [self stringByStrippingHTML:textToRead];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithData:[textToRead dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
            
            //NSLog(@"%@", attributedString.string);
            
            NSMutableString *html = [NSMutableString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"normalize.css\"><link rel=\"stylesheet\" type=\"text/css\" href=\"foundation.css\"><script src=\"modernizr.js\"></script><script src=\"jquery.js\"></script><script src=\"foundation.min.js\"></script><h3>%@</h3>", title];
            
            [html appendFormat:@"%@", jsonArray[@"content"]];
            
            Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:dataStore.managedObjectContext];
            article.url = articleURL;
            article.html = (NSString*)html;
            article.title = title;
            article.textToRead = attributedString.string;
            article.remainingTextToRead = attributedString.string;
            article.hasBegunReading = @0;
            article.dateAdded = [NSDate date];
            [dataStore save];
            NSLog(@"Done saving");
            
            //    [self.webView loadHTMLString:html baseURL:nil];
            //    self.textToRead = textToRead;
            
        } else {
            // Show Alert Somehow
            NSLog(@"Error sending to DiffBot");
            NSLog(@"%@", response);
            NSLog(@"%@", connectionError);
        }
        
        
        
        
    }];
}




// // DIFFBOT
//+(void)saveArticleToCoreData:(NSString*)articleURL dataStore:(DataStore*)dataStore{
//
//    articleURL = [articleURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//    NSString *escapedURL = [@"http://api.diffbot.com/v3/article?token=f573d590d93ff414652a15c5042141f0&url=" stringByAppendingString:articleURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
//                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                       timeoutInterval:10];
//    
//    [request setHTTPMethod: @"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        if (data){
//            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            
//            
//            NSString *textToRead = [NSString stringWithFormat:@".  %@", jsonArray[@"objects"][0][@"text"]];
//            
//            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"objects"][0][@"title"]];
//            textToRead = [title stringByAppendingString:textToRead];
//            
//            NSMutableString *html = [NSMutableString stringWithFormat:@"<style>img {max-width: 100%%; width: auto; height: auto;}</style><h3>%@</h3>", title];
//            
//            [html appendFormat:@"%@", jsonArray[@"objects"][0][@"html"]];
//            NSLog(@"HTML:  %@", html);
//            
//            
//            Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:dataStore.managedObjectContext];
//            article.url = articleURL;
//            article.html = (NSString*)html;
//            article.title = title;
//            article.textToRead = textToRead;
//            article.remainingTextToRead = textToRead;
//            article.hasBegunReading = @0;
//            article.dateAdded = [NSDate date];
//            [dataStore save];
//            NSLog(@"Done saving");
//            
//            //    [self.webView loadHTMLString:html baseURL:nil];
//            //    self.textToRead = textToRead;
//         
//        } else {
//            // Show Alert Somehow
//            NSLog(@"Error sending to DiffBot");
//            NSLog(@"%@", response);
//            NSLog(@"%@", connectionError);
//        }
//        
//        
//        
//        
//    }];
//}
@end
