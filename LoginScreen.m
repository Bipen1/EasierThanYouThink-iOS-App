//
//  LoginScreen.m
//  PracticeLoadURL
//
//  Created by An Qi on 4/24/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import "LoginScreen.h"
#import "CoursePickTableViewController.h"
#pragma mark NSURLConnection Delegate Methods

@interface LoginScreen ()

@end

@implementation LoginScreen

NSString const *separate = @"~~~~~";    // initialize constant

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Method that acts when getting a response from URL
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

// Method that acts when receiving data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the variable declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // Parse the stuff in instance variable now
    fullString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    [activityIndicator stopAnimating];      // Stop the activity indicator from spinning
    
    // Check if input was valid
    if ([fullString rangeOfString:@"Invalid input" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        // Create alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Verificaiton Failed" message:@"Incorrect User id, Password, or student number. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];   // show the alert to the user
    } else {
        // This will be for putting the course IDs and names into arrays
        NSArray *Courses = [fullString componentsSeparatedByString:@"~~~~~"];
        int count = [Courses count]/2;
        
        _CourseNames = [[NSMutableArray alloc] initWithCapacity:count];
        _IDsArray = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 2; i <= [Courses count]; i+=2) {
            [_CourseNames addObject:Courses[i-1]];
            [_IDsArray addObject:Courses[i-2]];
        }
        
        // Prepare for next segue, so send the string with question info
        [self performSegueWithIdentifier:@"PickCourse" sender:self.view];
    }
    
}

// This method is for carrying the data to the next segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PickCourse"]) {
        
        CoursePickTableViewController *CPTVC = [segue destinationViewController];
        CPTVC.CourseInfo = _CourseNames;
        CPTVC.CourseIDs = _IDsArray;
        CPTVC.Name = _Name;
        CPTVC.Pass = _Pass;
        CPTVC.StudentNum = _StudentNum;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    [activityIndicator stopAnimating];      // Stop the activity indicator
    // Create an alert to show the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot connect to server. Please check your internect connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];   // Show the alert to the user
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    activityIndicator.hidesWhenStopped = YES;   // Make sure that it won't be seen if no request is made
    
    // If the switch was "on" then set it to on and load the saved User and Pass
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveYes"]isEqualToString:@"true"]) {
        [saveInfo setOn:YES animated:YES];
    }
    
    if (saveInfo.on) {  // checks if save switch is literally "on" or off
        
        // For this app we will load the Username, Password and Student #
        UserInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        PassInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
        StudentInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"StudentNum"];
    }
    
}

-(IBAction)enterCredentials
{
    // Send server their username and password for verification
    // if the server verifies them then push screen to question page
    // if fail to connect then display error
    
    _Name = [UserInput.text lowercaseString];
    _Pass = [PassInput.text lowercaseString];
    _StudentNum = StudentInput.text;
    
    // String to be sent with URL request
    // May need to go over exact format of Username and Password
    NSString *stringToBeSent= [[NSString alloc] initWithFormat :
    @"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"getstudentcourses",separate,StudentInput.text];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [activityIndicator startAnimating];     // Start spinning to show request has been made
    
}

-(IBAction)saveCredentials  // This is a method for saving username and password
{
    if (saveInfo.on) {
        // If the switch is on, save the username, password, and "true" so we know it want to be saved
        NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:UserInput.text forKey:@"Username"];
        [_defaults setObject:PassInput.text forKey:@"Password"];
        [_defaults setObject:StudentInput.text forKey:@"StudentNum"];
        [_defaults setObject:@"true" forKey:@"SaveYes"];
        [_defaults synchronize];
    } else {
        // other case is "off", for this case, delete saved data
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
}

-(IBAction)textFieldShouldReturn:(UITextField *)textField
{
    // Gets rid of keyboard upon hitting return
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
