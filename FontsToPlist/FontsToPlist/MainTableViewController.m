//
//  MainTableViewController.m
//  FontsToPlist
//
//  Created by Ibrahim Qraiqe on 10/05/14.
//  Copyright (c) 2014 Ibrahim Qraiqe. All rights reserved.
//

#import "MainTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MainTableViewController ()<MFMailComposeViewControllerDelegate>{
    NSArray *allFonts;
    NSMutableArray *selectedFonts;
}
@property(nonatomic,weak)IBOutlet UITableView *fontsTableView;
@end

@implementation MainTableViewController

-(NSArray *)createAllFontsArray{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [array addObject:fontName];
        }
    }
    
    return array;
}

-(void)displayComposerSheet:(NSString *)fontsFilePath{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Fonts Plist File"];
    NSData *fileData = [NSData dataWithContentsOfFile:fontsFilePath];
    
    [picker addAttachmentData:fileData mimeType:@"plist" fileName:@"SelectedFonts.plist"];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    // Notifies users about errors associated with the interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc]initWithTitle:@"The file is save in Documents folder and sent to your email, you can find a copy of it in the simulator folder in your mac" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }else if(result == MFMailComposeResultFailed){
        [[[UIAlertView alloc]initWithTitle:@"The file is save in Documents folder and FAILD TO SEND IT BY EMAIL, you can find a copy of it in the simulator folder in your mac" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];

    }
}
-(void)save{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *selectedFontsPath = [docDir stringByAppendingPathComponent:@"SelectedFonts.plist"];

    [selectedFonts writeToFile:selectedFontsPath atomically:YES];
    if ([selectedFonts writeToFile:selectedFontsPath atomically:YES]) {
        [self displayComposerSheet:selectedFontsPath];
    }
}

-(void)unchceckAll{
    [selectedFonts removeAllObjects];
    for (int i = 0; i<allFonts.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UITableViewCell *cell = [self.fontsTableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [self setTitleString];
}

-(void)setTitleString{
    self.title = [NSString stringWithFormat:@"%d/%d fonts",selectedFonts.count,allFonts.count];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    

    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;

    UIBarButtonItem *unchceck = [[UIBarButtonItem alloc] initWithTitle:@"uncheck All" style:UIBarButtonItemStylePlain target:self action:@selector(unchceckAll)];
    self.navigationItem.leftBarButtonItem = unchceck;

    self.fontsTableView.rowHeight = (IS_IPAD)?100.0f:50;
    selectedFonts = [[NSMutableArray alloc]init];
    allFonts = [[self createAllFontsArray]copy];
    
    [self setTitleString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return allFonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *fontName = [allFonts objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:(IS_IPAD)?40.0f:20];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = .5;
    cell.textLabel.text = fontName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedFonts removeObject:[allFonts objectAtIndex:indexPath.row]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedFonts addObject:[allFonts objectAtIndex:indexPath.row]];
    }
    
    [self setTitleString];
}

@end
