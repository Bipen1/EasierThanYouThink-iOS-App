//
//  CoursePickTableViewController.h
//  PracticeLoadURL
//
//  Created by An Qi on 5/22/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import <UIKit/UIKit.h>

@interface CoursePickTableViewController : UITableViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;                           // for storing server's response
    NSString *fullString;                                   // for storing response as a string
}

@property (weak, nonatomic) NSString *cellText;             // going to store the cell's text on this
@property (weak, nonatomic) UITableViewCell *selectedCell;  // Selected cell, use for getting cell info

@property (strong, nonatomic) NSString *StudentNum;         // Student #
@property (strong, nonatomic) NSMutableArray *CourseInfo;   // Course Names
@property (strong, nonatomic) NSString *Name;               // User ID
@property (strong, nonatomic) NSString *Pass;               // Password
@property (strong, nonatomic) NSMutableArray *CourseIDs;    // Course ID #s
@property (strong, nonatomic) NSString *CourseID;           // Course ID of the course the user picked

@property (strong, nonatomic) NSMutableArray *Units;        // Unit names
@property (strong, nonatomic) NSMutableArray *UnitsID;      // Unit ID #s
@end
