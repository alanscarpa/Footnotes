//
//  ArticleViewController.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/2/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ArticleViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DataStore.h"


@interface ArticleViewController () <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;

@property (nonatomic, strong) NSString *textToRead;

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (nonatomic, strong) DataStore *dataStore;
@end

@implementation ArticleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    NSLog(@"Article begun reading: %@", self.article.hasBegunReading);
    
}

- (void) interruption:(NSNotification*)notification
{
    NSDictionary *interruptionDict = notification.userInfo;
    
    NSInteger interruptionType = [interruptionDict[@"AVAudioSessionInterruptionTypeKey"] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan){
        //        [self beginInterruption];
        NSLog(@"Interruption occurred");
        [self.dataStore save];
        
    } else if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        // [self endInterruption];
        NSLog(@"Interruption ended");
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    // Remove weird white space added by UIWebview at top of page
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataStore = [DataStore sharedDataStore];
    
    [self loadArticle:self.article];
    
}

-(void)loadArticle:(Article*)article{
    
        [self.webView loadHTMLString:self.article.html baseURL:nil];
    
    if ([article.hasBegunReading isEqual:@0]){
        // Read from the beginning of article
        self.textToRead = self.article.textToRead;
    } else {
        // Article has been at least partially read.
        // Therefore, pick up from where we left off.
        self.textToRead = self.article.remainingTextToRead;
    }
    
}


-(void)speakText:(NSString*)textToRead{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textToRead];
    utterance.rate = 0.085;
    utterance.pitchMultiplier = 0.85;
    utterance.volume = 0.8;

//    How to change voice accent
//    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
//    AVSpeechSynthesisVoice *newVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-AU"];
//    utterance.voice = newVoice;
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;

    [self.speechSynthesizer speakUtterance:utterance];
    
}



- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    
}




- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
    // called when each word is spoken
    // could use to highlight words
    // or even show progress maybe
    // NSLog(@"%@", NSStringFromRange(characterRange));
    // NSLog(@"%@", [utterance.speechString substringWithRange:characterRange]);
    //NSRange newRange = NSMakeRange(characterRange.location, utterance.speechString.length);
    
    NSRange newRange = NSMakeRange(characterRange.location, utterance.speechString.length - characterRange.location);
    self.article.remainingTextToRead = [utterance.speechString substringWithRange:newRange];
    
}

- (IBAction)listenButtonPressed:(id)sender {
    
    // STOP SPEAKING
    if ([[self.listenButton titleForState:UIControlStateNormal] isEqualToString:@"Stop Listening"]){
        [self.listenButton setTitle:@"Listen to Article" forState:UIControlStateNormal];
        [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        [self.dataStore save];
        
    } else {
        
    // START SPEAKING
        [self.listenButton setTitle:@"Stop Listening" forState:UIControlStateNormal];
        if ([self.speechSynthesizer isPaused]){
           [self.speechSynthesizer continueSpeaking];
        } else {
            if ([self.article.hasBegunReading isEqual: @0]){
                self.article.hasBegunReading = @1;
                [self.dataStore save];
                [self speakText:self.article.textToRead];
            } else {
                [self speakText:self.article.remainingTextToRead];
            }
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
        [self.dataStore save];

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
