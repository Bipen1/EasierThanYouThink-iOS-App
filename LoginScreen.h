//
//  LoginScreen.h
//  PracticeLoadURL
//
//  Created by An Qi on 4/24/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface LoginScreen : UIViewController<NSURLConnectionDelegate,UITextFieldDelegate>
{
    // declare some vars
    __weak IBOutlet UITextField *UserInput;         // This is the username input field
    __weak IBOutlet UITextField *PassInput;         // This is the password input field
    __weak IBOutlet UITextField *StudentInput;      // This is the student # input field
    NSMutableData *_responseData;                   // This will hold the reponse data from the url
    NSString *fullString;                           // Will use for holding string parsed from response
    __weak IBOutlet UISwitch *saveInfo;             // Button for saving username, password, and stu #
    NSUserDefaults *defaults;                       // Variable for storing user, pass and stu #
    __weak IBOutlet UIActivityIndicatorView *activityIndicator; // indicates if still getting server info
}
@property (strong, nonatomic) NSString *StudentNum; // Var for holding the student #
@property NSString *Name;                           // Var - holds username
@property NSString *Pass;                           // Var - holds password
@property NSMutableArray *IDsArray;                 // Array Var - holds all course IDs
@property NSMutableArray *CourseNames;              // Array Var - holds all course Names
- (IBAction)enterCredentials;                       // Method, will use URL to contact server
- (IBAction)textFieldShouldReturn:(UITextField *)textField; // Gets rid of the keyboard on hitting return
- (IBAction)saveCredentials;                        // Method for saving user, pass, stu #

@end
