//
//  UnitPickTableViewController.h
//  PracticeLoadURL
//
//  Created by An Qi on 5/30/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface UnitPickTableViewController : UITableViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    NSString *fullString;
}

@property (strong, nonatomic) NSString *StudentNum;     // String - holds student #
@property (strong, nonatomic) NSMutableArray *UnitInfo; // Array - holds unit names
@property (strong, nonatomic) NSString *Name;           // String - holds User ID
@property (strong, nonatomic) NSString *Pass;           // String - holds password
@property (strong, nonatomic) NSMutableArray *UnitIDs;  // Array - holds unit ID numbers
@property (strong, nonatomic) NSString *CourseID;       // String - holds chosen Course ID
@property NSString *UnitID;                             // String - holds chosen unit ID

@property NSMutableArray *Homework;                     // Homework Names
@property NSMutableArray *HomeworkIDs;                  // Homework IDs

@end
