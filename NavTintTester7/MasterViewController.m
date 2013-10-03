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

@property(nonatomic, strong) UIColor *navBarBackgroundTintColor;

@property(nonatomic, strong) UIColor *navButtonTintColor;

@property(weak, nonatomic) IBOutlet UITextField *navBarBackgroundTintTextField;
@property(weak, nonatomic) IBOutlet UITextField *navButtonColorTextField;
@property(weak, nonatomic) IBOutlet UITextField *navTitleColorTextField;

- (IBAction)chooseNavBackgroundHandler:(id) sender;

- (IBAction)navButtonColorHandler:(id) sender navButtonColor:(FCColorPickerViewController *) navButtonColor;

- (IBAction)navTitleColorHandler:(id) sender;

- (IBAction)navBarTranslucentHandler:(id) sender;

- (IBAction)sendToMailHandler:(id) sender;

- (IBAction)textFieldDidEnd:(id) sender;

@end

@implementation MasterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"navBarBackgroundTintColor" options:NSKeyValueObservingOptionNew context:@selector(updateNavBarBackgroundTintColor)];
    [self addObserver:self forKeyPath:@"navButtonTintColor" options:NSKeyValueObservingOptionNew context:@selector(updateNavButtonTintColor)];
    [self addObserver:self forKeyPath:@"navTitleColor" options:NSKeyValueObservingOptionNew context:@selector(updateNavTitleColor)];
}

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context {
    if (context != nil) {
        [self performSelector:context withObject:nil afterDelay:0];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"navBarBackgroundTintColor"];
    [self removeObserver:self forKeyPath:@"navButtonTintColor"];
    [self removeObserver:self forKeyPath:@"navTitleColor"];
}

- (FCColorPickerViewController *)newFCColorPickerViewController {
    FCColorPickerViewController *controller = [[FCColorPickerViewController alloc] initWithNibName:@"FCColorPickerViewController" bundle:[NSBundle mainBundle]];
    controller.color = self.view.backgroundColor;
    controller.delegate = self;
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    return controller;
}

- (IBAction)chooseNavBackgroundHandler:(id) sender {
    self.navBackgroundPicker = [self newFCColorPickerViewController];
    [self presentViewController:self.navBackgroundPicker animated:YES completion:nil];
}

- (IBAction)navButtonColorHandler:(id) sender navButtonColor:(FCColorPickerViewController *) navButtonColor {
    self.navButtonColorPicker = [self newFCColorPickerViewController];
    [self presentViewController:self.navButtonColorPicker animated:YES completion:nil];
}

- (IBAction)navTitleColorHandler:(id) sender {
    self.navTitleColorPicker = [self newFCColorPickerViewController];
    [self presentViewController:self.navTitleColorPicker animated:YES completion:nil];

}


- (void)updateNavBarBackgroundTintColor {
    [UINavigationBar appearance].barTintColor = self.navBarBackgroundTintColor;
    self.navigationController.navigationBar.barTintColor = self.navBarBackgroundTintColor;
}

- (void)updateNavButtonTintColor {
    [UINavigationBar appearance].tintColor = self.navButtonTintColor;
    self.navigationController.navigationBar.tintColor = self.navButtonTintColor;
}

- (void)updateNavTitleColor {
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : self.navTitleColor};
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navTitleColor};
}

- (void)colorPickerViewController:(FCColorPickerViewController *) colorPicker didSelectColor:(UIColor *) color {
    if ([colorPicker isEqual:self.navBackgroundPicker]) {
        self.navBarBackgroundTintColor = color;
    } else if ([colorPicker isEqual:self.navButtonColorPicker]) {
        self.navButtonTintColor = color;
    } else if ([colorPicker isEqual:self.navTitleColorPicker]) {
        self.navTitleColor = color;
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

- (IBAction)textFieldDidEnd:(UITextField *) sender {
    UIColor *color = [UIColor colorWithHexString:[sender text]];
    if (color == nil) {
        return;
    }
    if ([sender isEqual:self.navBarBackgroundTintTextField]) {
        self.navBarBackgroundTintColor = color;
    } else if ([sender isEqual:self.navButtonColorTextField]) {
        self.navButtonTintColor = color;
    } else if ([sender isEqual:self.navTitleColorTextField]) {
        self.navTitleColor = color;
    }
}


- (NSString *)colorDumpText {
    NSDictionary *colors = @{
        @"navBarBackgroundTintColor" : self.navBarBackgroundTintColor ? : [NSNull null],
        @"navButtonTintColor" : self.navButtonTintColor ? : [NSNull null],
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


- (void)textFieldDidEndEditing:(UITextField *) textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
