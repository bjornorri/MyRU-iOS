//
//  RUData.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 09/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUData.h"
#import "TFHpple.h"
#import "RUClass.h"
#import "RUAssignment.h"
#import "RUGrade.h"

@interface RUData()
    
    @property (strong, nonatomic) NSMutableString* basicAuthentication;
    @property (strong, nonatomic) NSMutableData* page;
    @property (strong, nonatomic) NSMutableData* timeTablePage;
    @property (strong, nonatomic) NSMutableArray* classes;
    @property (strong, nonatomic) NSMutableArray* assignments;
    @property (strong, nonatomic) NSMutableArray* grades;
    
- (void)setAuthentication:(NSString*)string;
    
    @end

@implementation RUData
    
    static RUData* sharedData = nil;
    
#pragma private
    
- (id)init
{
    self = [super init];
    if(self)
    {
        self.classes = [[NSMutableArray alloc] init];
        self.assignments = [[NSMutableArray alloc] init];
        self.grades = [[NSMutableArray alloc] init];
        self.basicAuthentication = [[NSUserDefaults standardUserDefaults] valueForKey:@"Authentication"];
    }
    return self;
}
    
- (bool)userIsLoggedIn
{
    return [self basicAuthentication] != nil;
}
    
- (NSString*)getAuthentication
{
    return [self basicAuthentication];
}
    
- (void)setAuthentication:(NSString *)string
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"Authentication"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(string)
    {
        self.basicAuthentication = [NSMutableString stringWithString:string];
    }
    else
    {
        self.basicAuthentication = nil;
    }
    
    return;
}
    
- (int)refreshData
{
    int statusCode1 = [self loadPage];
    int statusCode2 = [self loadTimeTablePage];
    if(statusCode1 == 200 && statusCode2 == 200)
    {
        NSLog(@"Refreshing data");
        [[self classes] removeAllObjects];
        [[self assignments] removeAllObjects];
        [[self grades] removeAllObjects];
        [self parseHTML];
        
        NSLog(@"Classes today:\n");
        NSLog(@"\n---------------------------------------------------------------------------------------------\n");
        for(RUClass* class in [self classes])
        {
            NSLog(@"%@", [class course]);
            
            NSMutableString* teachers = [[class teachers] firstObject];
            for(int i = 1; i < [class.teachers count]; i++)
            {
                [teachers appendString:@", "];
                [teachers appendString:[class.teachers objectAtIndex:i]];
            }
            NSLog(@"Kennari: %@", teachers);
            NSLog(@"Stofa: %@", [class location]);
            NSLog(@"%@", [class type]);
            NSLog(@"%@ - %@", [class startTime], [class endTime]);
            NSLog(@"\n---------------------------------------------------------------------------------------------\n");
        }
    }
    
    else if(statusCode1 == 200)
    {
        NSLog(@"Status codes not the same!");
        return statusCode2;
    }
    else if(statusCode2 == 200)
    {
        NSLog(@"Status codes not the same!");
        return statusCode1;
    }
    return statusCode1;
}
    
- (void)clearData
{
    [[self classes] removeAllObjects];
    [[self assignments] removeAllObjects];
    [[self grades] removeAllObjects];
    self.page = nil;
    self.timeTablePage = nil;
    [self setAuthentication:nil];
}

- (NSArray*)getClasses
{
    return [self classes];
}

- (NSArray*)getAssignments
{
    return [self assignments];
}
    
- (NSArray*)getGrades
{
    return [self grades];
}
    
    
    // Load the page into self.page. Return the status code of the HTTP response (intended for login check).
- (int)loadPage
{
    NSURL* myschoolURL = [NSURL URLWithString:@"https://myschool.ru.is/myschool/?Page=Exe&ID=1.12"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:myschoolURL];
    [request setValue:self.basicAuthentication forHTTPHeaderField:@"Authorization"];
    NSHTTPURLResponse* response;
    self.page = [NSMutableData dataWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
    int statusCode = (int)[response statusCode];
    NSLog(@"Status Code: %d", statusCode); // Debug code
    return statusCode;
}

- (int)loadTimeTablePage
{
    NSURL* myschoolURL = [NSURL URLWithString:@"https://myschool.ru.is/myschool/?Page=Exe&ID=3.2"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:myschoolURL];
    [request setValue:self.basicAuthentication forHTTPHeaderField:@"Authorization"];
    NSHTTPURLResponse* response;
    self.timeTablePage = [NSMutableData dataWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
    int statusCode = (int)[response statusCode];
    NSLog(@"Status Code: %d", statusCode); // Debug code
    return statusCode;
}
    
- (void)parseHTML
{
    if(self.page && self.timeTablePage)
    {
        // Assignments and grades
        TFHpple* htmlPageParser = [TFHpple hppleWithHTMLData:self.page];
        
        NSString* XpathQueryString = @"//div[@class='ruContentPage']/center/table";
        NSArray* tables = [htmlPageParser searchWithXPathQuery:XpathQueryString];
        NSArray* hppleClasses;
        NSArray* hppleAssignments;
        NSArray* hppleGrades;
        
        if([tables count] == 2)
        {
            NSString* assignmentString = @"//div[@class='ruContentPage']/center/table[@class='ruTable']/tbody/tr";
            NSString* gradeString = @"//div[@class='ruContentPage']/center[2]/table/tbody/tr";
            
            hppleAssignments = [htmlPageParser searchWithXPathQuery:assignmentString];
            hppleGrades = [htmlPageParser searchWithXPathQuery:gradeString];
        }
        else if([tables count] == 1)
        {
            NSString* tableHeaderString = @"//div[@class='ruContentPage']/h4";
            NSArray* arr = [htmlPageParser searchWithXPathQuery:tableHeaderString];
            NSString* header = [arr[0] text];
            NSLog(@"The table header is: %@", header);
            
            // There are only assignments, no grades
            if([header isEqualToString:@"Næstu verkefni"])
            {
                NSString* assignmentString = @"//div[@class='ruContentPage']/center/table[@class='ruTable']/tbody/tr";
                hppleGrades = nil;
                hppleAssignments = [htmlPageParser searchWithXPathQuery:assignmentString];
            }
            // There are only grades, no assignments
            else
            {
                NSString* gradeString = @"//div[@class='ruContentPage']/center/table[@class='ruTable']/tbody/tr";
                hppleAssignments = nil;
                hppleGrades = [htmlPageParser searchWithXPathQuery:gradeString];
            }
        }
        else
        {
            NSLog(@"RUData.m - Table array is empty!!!");
            hppleAssignments = nil;
            hppleGrades = nil;
        }
        [self parseAssignments:hppleAssignments];
        [self parseGrades:hppleGrades];
        
        // Timetable
        TFHpple* htmlTimeTableParser = [TFHpple hppleWithHTMLData:self.timeTablePage];
        NSString* timeTableQueryString = @"//div[@class='ruContentPage']/center[1]/table";
        NSArray* timeTable = [htmlPageParser searchWithXPathQuery:timeTableQueryString];
        
        if([timeTable count] == 1)
        {
            NSLog(@"Got timetable!");
            NSString* classString = @"//div[@class='ruContentPage']/center[1]/table/tbody/tr";
            hppleClasses = [htmlTimeTableParser searchWithXPathQuery:classString];
        }
        else
        {
            hppleClasses = nil;
        }
        [self parseClasses:hppleClasses];
    }
}

- (void)parseClasses:(NSArray*)data
{
    if([data count])
    {
        // Get a number for the day of the week, this is used as a column index for the timetable
        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        int column = (int)[comps weekday];
        
        // Extract the rows that contain valuable data
        NSMutableArray* rows = [[NSMutableArray alloc] init];
        for(int i = 3; i < [data count] - 1; i++)
        {
            [rows addObject:data[i]];
        }
        
        for(TFHppleElement* row in rows)
        {
            if([row hasChildren])
            {
                NSArray* columns = [row childrenWithTagName:@"td"];
                
                // Just to be sure...
                if([columns count] == 8)
                {
                    // Fetch today's column from the row
                    TFHppleElement* todayColumn = columns[column];
                    
                    if([[todayColumn childrenWithTagName:@"span"] count] > 0)
                    {
                        for(TFHppleElement* classSpan in [todayColumn childrenWithTagName:@"span"])
                        {
                            NSString* infoString = [[classSpan attributes] objectForKey:@"title"];
                            NSArray* info = [infoString componentsSeparatedByString:@"\n"];
                            RUClass* class = [[RUClass alloc] init];
                            
                            // Set course
                            class.course = info[0];
                            
                            // Set type
                            if([info[2] rangeOfString:@"Fyrirlestrar"].location == 0)
                            {
                                class.type = @"Fyrirlestur";
                            }
                            else if([info[2] rangeOfString:@"Dæmatímar"].location == 0)
                            {
                                class.type = @"Dæmatími";
                            }
                            else
                            {
                                class.type = info[2];
                            }
                            
                            // Set teachers (i starts at 0 on purpose, just in case something is not as it should be)
                            for(int i = 0; i < [info count]; i++)
                            {
                                if([info[i] rangeOfString:@"Kennari: "].location == 0)
                                {
                                    [[class teachers] addObject:[info[i] substringFromIndex:9]];
                                }
                            }
                            
                            // Set location
                            TFHppleElement* link = [[classSpan firstChildWithTagName:@"a"] firstChildWithTagName:@"small"];
                            NSString* locationString = [[[link children] objectAtIndex:2] content]; // Includes "stofa: "
                            NSString* location = [locationString substringFromIndex:6];
                            class.location = location;
                            
                            // Set start and end time
                            TFHppleElement* timeColumn = columns[0];
                            NSArray* time = [[timeColumn text] componentsSeparatedByString:@" "]; // &nbsp
                            class.startTime = time[0];
                            class.endTime = time[1];
                            
                            // Add to classes
                            [[self classes] addObject:class];
                        }
                    }
                }
            }
        }
    }
}
    
- (void)parseAssignments:(NSArray*)data
{
    if([data count])
    {
        for(int i = 0; i < [data count] - 1; i++){
            [self.assignments addObject:[[RUAssignment alloc] init]];
            
        }
        int editing = 0;
        for (TFHppleElement* element in data) {
            if([element hasChildren]){
                int counter = 0;
                for(TFHppleElement* child in [element children]){
                    if([child text]){
                        switch (counter) {
                            case 0:
                            [[self.assignments objectAtIndex:editing] setDueDate:[[child text] substringToIndex:5]];
                            break;
                            case 1:
                            [[self.assignments objectAtIndex:editing] setHandedIn:[child text]];
                            case 2:
                            [[self.assignments objectAtIndex:editing] setCourseId:[child text]];
                            case 3:
                            [[self.assignments objectAtIndex:editing] setCourseName:[child text]];
                            default:
                            break;
                        }
                        counter++;
                    }
                    if([child hasChildren]){
                        for (TFHppleElement* grandchild in [child children]) {
                            if ([grandchild text]) {
                                [[self.assignments objectAtIndex:editing] setTitle:[grandchild text]];
                            }
                            if([[grandchild tagName]  isEqual: @"a"]){
                                [[self.assignments objectAtIndex:editing] setAssignmentURL:[grandchild objectForKey:@"href"]];
                            }
                        }
                    }
                }
                editing++;
            }
        }
        if([self.assignments count] > 1){
            [self.assignments removeObjectAtIndex:0];
        }
    }
    return;
}
    
- (void)parseGrades:(NSArray*)data
{
    if([data count])
    {
        NSMutableArray* grades = [[NSMutableArray alloc] init];
        NSString* currentCourse = nil;
        for (TFHppleElement* element in data) {
            RUGrade* thisGrade = [[RUGrade alloc] init];
            if([element hasChildren]){
                int counter = 0;
                for(TFHppleElement* child in [element children]){
                    if([child text]){
                        if([[child tagName] isEqualToString:@"th"]){
                            currentCourse = [child text];
                            continue;
                        }
                        switch (counter) {
                            case 0:
                            [thisGrade setGrade:[child text]];
                            break;
                            case 1:
                            [thisGrade setOrder:[child text]];
                            case 2:
                            [thisGrade setFeedback:[child text]];
                            default:
                            break;
                        }
                        [thisGrade setInCourse:currentCourse];
                        counter++;
                    }
                    if([child hasChildren]){
                        for (TFHppleElement* grandchild in [child children]) {
                            if ([grandchild text]) {
                                [thisGrade setAssignmentName:[grandchild text]];
                            }
                        }
                    }
                }
                [grades addObject:thisGrade];
            }
        }
        // This is awesome! Didn't know Obj-C had this block syntax
        [grades sortUsingComparator:^(RUGrade* obj1, RUGrade* obj2){
            return (NSComparisonResult)[obj1.inCourse compare:obj2.inCourse];
        }];
        NSString* thisCourseName;
        // Loop through all the grades
        for(int i = 0; i < grades.count;){
            // Create an array for the current course
            NSMutableArray* thisCourse = [[NSMutableArray alloc] init];
            thisCourseName = [[grades objectAtIndex:i] inCourse];
            // While we are still in that course, push the grade
            while(i < grades.count && [[[grades objectAtIndex:i] inCourse] isEqualToString:thisCourseName])
            {
                if([[grades objectAtIndex:i] assignmentName] != nil)
                {
                    [thisCourse addObject:[grades objectAtIndex:i]];
                }
                i++;
            }
            //Push new array to the data store
            if(thisCourse.count > 0)
            {
                [[self grades] addObject:thisCourse];
            }
            // Super-secret increment
            else
            {
                ++i;
            }
        }
    }
    else
    {
        NSLog(@"No grades data!");
    }
    return;
}
    
    
    
#pragma public
    
    // Get the shared instance and create it if necessary.
+ (id)sharedData
{
    if(sharedData != nil)
    {
        return sharedData;
    }
    else
    {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            sharedData = [[RUData alloc] init];
        });
        return sharedData;
    }
}

@end