//
//  QuestionDisplay.h
//  PracticeLoadURL
//
//  Created by An Qi on 4/9/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface QuestionDisplay : UIViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    NSString *fullString;
}
@property (weak, nonatomic) IBOutlet UIWebView *WebDisplay;         // Show question
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;           // Count down after hitting "Check"
@property (weak, nonatomic) IBOutlet UILabel *TargetLabel;          // Show target time
@property (weak, nonatomic) IBOutlet UILabel *TimeTaken;            // Show curr time
@property (weak, nonatomic) IBOutlet UILabel *DisplayCorrect;       // Show # of correct
@property (weak, nonatomic) IBOutlet UILabel *DisplayIncorrect;     // Show # incorrect
@property (weak, nonatomic) IBOutlet UILabel *PercentDisplay;       // Show % of correct/incorrect

// Variables that send connection requests to server
@property NSURLConnection *conn;        // This asks for the question, answer, and solution
@property NSURLConnection *connLog;     // This one asks for user statistics

@property NSInteger CurrentQuestion;    // This Var will hold the current question #

@property NSMutableArray *Sols;         // Array for holding the solutions

@property IBOutlet UISegmentedControl *Choice;  // The equivalent of radio buttons for choosing answer

@property (weak, nonatomic) IBOutlet UIButton *Check;   // button for "check"

@property NSString *htmlquestion;       // String that holds the html of the question

@property NSString *Answer;         // String - the full solution
@property NSString *Question;       // String - the question text
@property NSArray *Answers;         // Array - the list of answers
@property NSInteger CorrectChoice;  // int - the "number" of the correct answer
@property NSInteger NumOfQuests;    // int - the # of questions in the homework set
@property NSString *TargetTime;     // String - Target time

@property (strong, nonatomic) NSString *StudentNum;     // String - Student #
@property (strong, nonatomic) NSString *Name;           // String - User ID
@property (strong, nonatomic) NSString *Pass;           // String - Password
@property NSString *HomeworkID;                         // String - Homework ID that user picked
@property (strong, nonatomic) NSString *CourseID;       // String - Course ID that user picked
@property NSString *questionID;                         // String - holds question ID
@property NSString *YesOrNo;                            // String - is question is correct or not             

@property NSString *StartTime;      // String - holds start time
@property NSString *EndTime;        // String - holds end time
@property int CountDownNum;         // int - 40 second count down
@property NSTimer *Timer;           // a timer for the 40 second count down

- (IBAction)CheckButton:(id)sender;     // The check button for showing 4 answers to choose from
- (IBAction)SegmentChoice:(id)sender;   // Check which answer user selected
- (void)getURL;                         // Get url info like question or statistics
- (void)setStartTime;                   // Set the time the question started
- (void)CountDown;                      // Count down 40 seconds after hitting "check"
- (void)SendYesNo;                      // Method for sending if user was correct/incorrect

@end
