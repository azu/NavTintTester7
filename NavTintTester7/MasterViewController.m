//
//  MasterViewController.m
//  NavTintTester7
//
//  Created by azu on 2013/10/02.
//  Copyright (c) 2013年 azu. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MasterViewController.h"
#import "UIColor+Expanded.h"

@interface MasterViewController ()
@property(weak, nonatomic) IBOutlet UIView *navigationBackgroundButton;

@property(nonatomic, strong) FCColorPickerViewController *navBackgroundPicker;

@property(nonatomic, strong) FCColorPickerViewController *navButtonColorPicker;

@property(nonatomic, strong) FCColorPickerViewController *navTitleColorPicker;

@property(nonatomic, strong) UIColor *navTitleColor;

- (IBAction)chooseNavBackgroundHandler:(id) sender;

- (IBAction)navButtonColorHandler:(id) sender navButtonColor:(FCColorPickerViewController *) navButtonColor;

- (IBAction)navTitleColorHandler:(id) sender;

- (IBAction)navBarTranslucentHandler:(id) sender;

- (IBAction)sendToMailHandler:(id) sender;
@end

@implementation MasterViewController
- (void)viewDidLoad {

    [super viewDidLoad];
}

- (IBAction)chooseNavBackgroundHandler:(id) sender {
    self.navBackgroundPicker = [[FCColorPickerViewController alloc]
        initWithNibName:@"FCColorPickerViewController" bundle:[NSBundle mainBundle]];
    self.navBackgroundPicker.color = self.view.backgroundColor;
    self.navBackgroundPicker.delegate = self;
    [self.navBackgroundPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:self.navBackgroundPicker animated:YES completion:nil];
}

- (IBAction)navButtonColorHandler:(id) sender navButtonColor:(FCColorPickerViewController *) navButtonColor {
    self.navButtonColorPicker = [[FCColorPickerViewController alloc] initWithNibName:@"FCColorPickerViewController"
                                                                     bundle:[NSBundle mainBundle]];
    self.navButtonColorPicker.color = self.view.backgroundColor;
    self.navButtonColorPicker.delegate = self;
    [self.navButtonColorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:self.navButtonColorPicker animated:YES completion:nil];
}

- (IBAction)navTitleColorHandler:(id) sender {
    self.navTitleColorPicker = [[FCColorPickerViewController alloc]
        initWithNibName:@"FCColorPickerViewController"
        bundle:[NSBundle mainBundle]];
    self.navTitleColorPicker.color = self.view.backgroundColor;
    self.navTitleColorPicker.delegate = self;

    [self.navTitleColorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:self.navTitleColorPicker animated:YES completion:nil];

}


- (void)colorPickerViewController:(FCColorPickerViewController *) colorPicker didSelectColor:(UIColor *) color {
    if ([colorPicker isEqual:self.navBackgroundPicker]) {
        [UINavigationBar appearance].barTintColor = color;
    } else if ([colorPicker isEqual:self.navButtonColorPicker]) {
        [UINavigationBar appearance].tintColor = color;
    } else if ([colorPicker isEqual:self.navTitleColorPicker]) {
        self.navTitleColor = color;
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : color};
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *) colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)navBarTranslucentHandler:(UISwitch *) sender {
    self.navigationController.navigationBar.translucent = sender.isOn;
}

- (IBAction)sendToMailHandler:(id) sender {
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
    [composeViewController setSubject:@"Color"];
    [composeViewController setMailComposeDelegate:self];
    [composeViewController setMessageBody:[self colorDumpText] isHTML:NO];
    [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
}

- (NSString *)colorDumpText {
    NSDictionary *colors = @{
        @"barTintColor" : [UINavigationBar appearance].barTintColor ? : [NSNull null],
        @"tintColor" : [UINavigationBar appearance].tintColor ? : [NSNull null],
        @"navTitleColor" : self.navTitleColor ? : [NSNull null],
    };
    NSMutableString *dump = [NSMutableString string];
    [dump appendString:[NSString stringWithFormat:@"translucent = %@\n",
                                                  self.navigationController.navigationBar.translucent
                                                  ? @"YES" : @"NO"]];
    for (NSString *key in colors) {
        UIColor *color = colors[key];
        if (![color isEqual:[NSNull null]]) {
            [dump appendString:[NSString stringWithFormat:@"%@ = #%@\n", key, [color hexStringFromColor]]];
        }
    }
    return dump;
}

- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult) result
                        error:(NSError *) error {

    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
