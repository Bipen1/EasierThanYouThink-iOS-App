//
//  QuestionDisplay.m
//  PracticeLoadURL
//
//  Created by An Qi on 4/9/14.
//  Copyright (c) 2014 An Qi. All rights reserved.
//
//  Co-Developers: An Qi Zhang & Bipenjot Grewal
//

#import "QuestionDisplay.h"
#import "SolutionViewController.h"
@interface QuestionDisplay ()

@end

@implementation QuestionDisplay

#pragma mark NSURLConnection Delegate Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Show the target time
    [_TargetLabel setText:[NSString stringWithFormat:@"Target Time: %@min",_TargetTime]];
    
    _CurrentQuestion = 0;   // set the current question from homework set to 0
    [_CountLabel setHidden:YES];    // Hide the 40 sec count down label
    
    [[self Choice] setHidden:YES];  // hide segmented controller
    
    // Set the segmented controller (its like the "radio button") to none selected
    [_Choice setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self getURL];          // Get the question, answer, solution
    [self setStartTime];    // Get the time started
}

- (void)setStartTime {
    // Get current date time
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    [dateFormatter setDateFormat:@"HH:mm"];
    
    // Set the time started
    _StartTime = [dateFormatter stringFromDate:currentDateTime];
}

- (void)getElapsedTime {
    NSDate *currentDateTime = [NSDate date];                            // Retrieves current time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    // instantiate a date formatter
    [dateFormatter setDateFormat:@"HH:mm"];                             // Formats to Miltary Time
    _EndTime =  [dateFormatter stringFromDate:currentDateTime];         // Set the time ended
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    // parse the resonse to a string var
    fullString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    // Since multiple requests are made, we need to change the way we handed the reponse for each request
    if (connection == self.conn) {
        // This is the separating the question reponse into question, answer, and solution
        NSArray *Parts = [fullString componentsSeparatedByString:@"%$%"];
        _Question = Parts[0];
        NSArray *Sol = [Parts[1] componentsSeparatedByString:@"~"];
        _Answer = [Parts[2] componentsSeparatedByString:@"~~~~~"][0];
        _questionID = [Parts[2] componentsSeparatedByString:@"~~~~~"][1];
        _Sols = [[NSMutableArray alloc] initWithArray:Sol];
        
        for (NSUInteger i = 1; i < [_Sols count]; ++i) {
            // Select a random element between i and end of array to swap with. Randomizes answers order
            NSInteger nElements = [_Sols count] - i;
            NSInteger n = arc4random_uniform(nElements) + i;
            [_Sols exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        
        _CorrectChoice = 0;     // reset the correct choice to 0
        
        // This figures out which choice is the correct one and remembers it
        for (NSInteger i = 1; i < [_Sols count]; i++) {
            if ([_Sols[i] isEqualToString:_Sols[0]]) {
                _CorrectChoice = i;
                break;
            }
        }
        
        // Loads the UIWebDisplay with the html from the solution
        _htmlquestion = [NSString stringWithFormat:@"%@",_Question];
        [_WebDisplay loadHTMLString:_htmlquestion baseURL:nil];
        
        // Resets the segmented controller (radio buttons) to none
        [_Choice setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        // Set the start time for the question
        [self setStartTime];
        
    } else if (connection == self.connLog) {
        // This is for handling the response from the get user statistics method, it displays the stats
        NSArray *Log = [fullString componentsSeparatedByString:@","];
        _TimeTaken.text = [NSString stringWithFormat:@"%@ min", Log[1]];
        _DisplayCorrect.text = [NSString stringWithFormat:@"Correct: %@", Log[2]];
        _DisplayIncorrect.text = [NSString stringWithFormat:@"Incorrect: %@", Log[3]];
        
        // Calculates the % of the user's preformance, avoids calculating if it starts at 0 and 0
        if ([Log[2] intValue] != 0 || [Log[3] intValue] != 0) {
            _PercentDisplay.text = [NSString stringWithFormat:@"%d%%", (int)(100*( [Log[2] floatValue] / ([Log[3] floatValue] + [Log[2] floatValue])))];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    // Create an alert to show the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot connect to server. Please check your internect connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];   // show ther alert to the user
    
    // Take the user back to the login screen if there's an error
    [self performSegueWithIdentifier:@"UnwindIfError" sender:self];
}

- (IBAction)CheckButton:(id)sender
{
    [[self Choice] setHidden:NO];   // Show the segmented controller (radio buttons) after pressing check
    
    // Display the choices after they press "check"
    _htmlquestion = [NSString stringWithFormat:@"%@<br>1) %@<br>2) %@<br>3) %@<br>4) %@",_Question,_Sols[1],_Sols[2],_Sols[3],_Sols[4]];
    [_WebDisplay loadHTMLString:_htmlquestion baseURL:nil];
    
    // 40 Second Countdown initiated
    _CountDownNum = 40;
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown) userInfo:nil repeats:YES];
}

// Method for the 40 second count down timer
- (void)CountDown
{
    [_CountLabel setHidden:NO]; // Show the 40 sec count down
    _CountDownNum -= 1;         // subtract one each second
    _CountLabel.text = [NSString stringWithFormat:@"%i", _CountDownNum];    // update the count down
    
    // If user runs out of time
    if (_CountDownNum == 0) {
        // end the timer
        [_Timer invalidate];
        
        // Get the end time
        [self getElapsedTime];
        
        // Now send incorrect
        _YesOrNo = @"no";
        [self SendYesNo];
        
        // get new question
        [self getURL];
        // get new start time
        [self setStartTime];
        // hide 40 sec counter now
        [_CountLabel setHidden:YES];
        // push to solution page
        [self performSegueWithIdentifier:@"ToSolution" sender:self.view];
    }
}

- (IBAction)SegmentChoice:(id)sender
{
    [self getElapsedTime];  // get the end time
    
    // Act based on if user got question right or wrong
    if (_Choice.selectedSegmentIndex == _CorrectChoice - 1) {
        if (_CurrentQuestion < _NumOfQuests) {
            _CurrentQuestion++;     // user was correct, go to next Question
        } else {
            _CurrentQuestion = 0;   // highest question reached, set back to zero
        }
        
        // Now send that they got correct
        _YesOrNo = @"yes";
        [self SendYesNo];
        
        // Get new question & other stuff and set the starting time
        [self getURL];
        [self setStartTime];
    } else {
        // Send that they got it incorrect
        _YesOrNo = @"no";
        [self SendYesNo];
        
        // Get the question again & other stuff, and set the starting time
        [self getURL];
        [self setStartTime];
        
        // push to solution page
        [self performSegueWithIdentifier:@"ToSolution" sender:self.view];
    }
    
    // Must hide segmented controller (radio buttons) now
    [[self Choice] setHidden:YES];
    // stop 40 second timer
    [_Timer invalidate];
    // hide timer when done
    [_CountLabel setHidden:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToSolution"]) {
        // Bring the answer to the next segue
        SolutionViewController *SVC = [segue destinationViewController];
        SVC.Answer = _Answer;
    }
}

-(void)SendYesNo {
    NSString const *separate = @"~~~~~";
    
    NSString *stringToBeSent= [[NSString alloc] initWithFormat:
                               @"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"savehomeworksstatforastudent",separate,_StudentNum,separate,_CourseID,separate,_HomeworkID,separate,_YesOrNo,separate,_StartTime,separate,_EndTime,separate,_questionID];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Send if the user got the answer correct or incorrect
    NSURLConnection *SaveYesNo = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getURL {
    NSString const *separate = @"~~~~~";
    
    // String to be sent with URL request
    NSString *stringToBeSent= [[NSString alloc] initWithFormat:
                               @"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@%@%d",_Name,separate,_Pass,separate,@"gethomeworkquestion",separate,_HomeworkID,separate,_CurrentQuestion];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // Create url connection and fire request, This one is for the question, answer, and solution
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    stringToBeSent= [[NSString alloc] initWithFormat:
                     @"http://www.easierthanyouthink.ca/verification.asp?%@%@%@%@%@%@%@%@%@",_Name,separate,_Pass,separate,@"gethomeworksstatforastudent",separate,_StudentNum,separate,_HomeworkID];
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToBeSent] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    // This one is for the homework stats
    _connLog = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
