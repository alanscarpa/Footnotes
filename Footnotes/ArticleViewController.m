//
//  ArticleViewController.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/2/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ArticleViewController.h"
#import <AVFoundation/AVFoundation.h>




@interface ArticleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;

@property (nonatomic, strong) NSString *textToRead;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    // Remove weird white space added by UIWebview at top of page
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadArticle:self.article];
    
}

-(void)loadArticle:(Article*)articleURL{
    
        [self.webView loadHTMLString:self.article.html baseURL:nil];
        
        self.textToRead = self.article.textToRead;
    
}


-(void)speakText:(NSString*)textToRead{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textToRead];
    utterance.rate = 0.085;
    utterance.pitchMultiplier = 0.25;
    utterance.volume = 0.8;
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
    [self.speechSynthesizer speakUtterance:utterance];
    
}

- (IBAction)listenButtonPressed:(id)sender {
    
    //NSLog(@"%@", self.textToRead);

    
    if ([[self.listenButton titleForState:UIControlStateNormal] isEqualToString:@"Stop Listening"]){
        [self.listenButton setTitle:@"Listen to Article" forState:UIControlStateNormal];
        [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    } else {
        [self.listenButton setTitle:@"Stop Listening" forState:UIControlStateNormal];
        
        if ([self.speechSynthesizer isPaused]){
           [self.speechSynthesizer continueSpeaking];
        } else {
            
            [self speakText:self.textToRead];

        }

    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"leaving!");
    if ([self.speechSynthesizer isSpeaking]){
        [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
     }
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [self.speechSynthesizer speakUtterance:utterance];
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
   
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
}


@end
