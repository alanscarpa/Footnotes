//
//  ViewController.m
//  Footnotes
//
//  Created by Alan Scarpa on 6/23/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "LoginViewController.h"
#import "ActionRequestHandler.h"

@interface LoginViewController ()

@property (nonatomic, strong) ActionRequestHandler *actionHandler;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
   
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVSpeechSynthesizerDelegate

// REMEMBER TO MAKE SELF DELEGATE IF USING THESE

//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
//willSpeakRangeOfSpeechString:(NSRange)characterRange
//                utterance:(AVSpeechUtterance *)utterance
//{
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:utterance.speechString];
//    [mutableAttributedString addAttribute:NSForegroundColorAttributeName
//                                    value:[UIColor redColor] range:characterRange];
//    self.utteranceLabel.attributedText = mutableAttributedString;
//}
//
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
// didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
//{
//    self.utteranceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
//}

@end
