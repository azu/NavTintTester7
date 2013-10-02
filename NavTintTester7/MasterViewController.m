//
//  MasterViewController.m
//  NavTintTester7
//
//  Created by azu on 2013/10/02.
//  Copyright (c) 2013年 azu. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
@property(weak, nonatomic) IBOutlet UIView *navigationBackgroundButton;

@property(nonatomic, strong) FCColorPickerViewController *navBackgroundPicker;

@property(nonatomic, strong) FCColorPickerViewController *navButtonColorPicker;

@property(nonatomic, strong) FCColorPickerViewController *navTitleColorPicker;

- (IBAction)chooseNavBackgroundHandler:(id) sender;

- (IBAction)navTitleColorHandler:(id) sender;

- (IBAction)navBarTranslucentHandler:(id) sender;

- (IBAction)navButtonColorHandler:(id) sender;
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
    }else if ([colorPicker isEqual:self.navTitleColorPicker]) {
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: color};
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *) colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)navBarTranslucentHandler:(UISwitch *) sender {
    self.navigationController.navigationBar.translucent = sender.isOn;
}

- (IBAction)navButtonColorHandler:(id) sender {
}
@end
