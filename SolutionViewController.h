//
//  SolutionViewController.h
//  PracticeLoadURL
//
//  Created by An Qi on 6/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface SolutionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *DisplaySol; // This is the UIWebView for the solution
@property NSString *Answer;     // String that holds the solution html

@end
