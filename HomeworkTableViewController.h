//
//  HomeworkTableViewController.h
//  PracticeLoadURL
//
//  Created by An Qi on 6/1/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface HomeworkTableViewController : UITableViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;   
    NSString *fullString;
}

@property (strong, nonatomic) NSString *StudentNum;     // Student #
@property (strong, nonatomic) NSString *Name;           // User ID, also use Self.Name when necessary
@property (strong, nonatomic) NSString *Pass;           // Password
@property (strong, nonatomic) NSString *CourseID;       // Course ID that user picked
@property NSString *UnitID;                             // Unit ID that user picked
@property NSString *HomeworkID;                         // Homework ID that user picked
@property NSInteger NumOfQuests;                        // Number of Questions (got from url request)
@property NSString *TargetTime;                         // Target time (got from url request)

@property NSMutableArray *Homework;                     // Homework Names
@property NSMutableArray *HomeworkIDs;                  // Homework IDs

@end
