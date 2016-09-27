//
//  RMPickerViewController.m
//  RMPickerViewController
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013-2015 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMPickerViewController.h"
#import <QuartzCore/QuartzCore.h>


#define RM_PICKER_HEIGHT_PORTRAIT 216
#define RM_PICKER_HEIGHT_LANDSCAPE 162

#if !__has_feature(attribute_availability_app_extension)
//Normal App
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
#else
//App Extension
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE [UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width
#endif

@interface RMPickerViewController ()

@property (nonatomic, readwrite, strong) UIPickerView *picker;
@property (nonatomic, weak) NSLayoutConstraint *pickerHeightConstraint;

@end

@implementation RMPickerViewController

#pragma mark - Class
- (instancetype)initWithStyle:(RMActionControllerStyle)style title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:style title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.picker.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.pickerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_PORTRAIT;
        }
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            aPickerViewController.backgroundView.alpha = 1;
            
            [aPickerViewController.rootViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    } else {
        aPickerViewController.backgroundView.alpha = 0;
        
        [aPickerViewController.rootViewController.view layoutIfNeeded];
    }
}

+ (void)dismissPickerViewController:(RMPickerViewController *)aPickerViewController {
    [aPickerViewController.rootViewController.view removeConstraint:aPickerViewController.yConstraint];
    aPickerViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aPickerViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:aPickerViewController.rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
       @try {
            [aPickerViewController.rootViewController.view addConstraint:aPickerViewController.yConstraint];
        } @catch (NSException *e) {
            // eat this exception occasionally show up.
        } 
    
    [aPickerViewController.rootViewController.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        aPickerViewController.backgroundView.alpha = 0;
        
        [aPickerViewController.rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [aPickerViewController willMoveToParentViewController:nil];
        [aPickerViewController viewWillDisappear:YES];
        
        [aPickerViewController.view removeFromSuperview];
        [aPickerViewController removeFromParentViewController];
        
        [aPickerViewController didMoveToParentViewController:nil];
        [aPickerViewController viewDidDisappear:YES];
        
        [aPickerViewController.backgroundView removeFromSuperview];
        aPickerViewController.window = nil;
        aPickerViewController.hasBeenDismissed = NO;
    }];
}

#pragma mark - Init and Dealloc
- (id)init {
    self = [super init];
    if(self) {
        self.blurEffectStyle = UIBlurEffectStyleExtraLight;
        
        [self setupUIElements];
=======
        [self.picker addConstraint:self.pickerHeightConstraint];
>>>>>>> af3b8a514cd2bbb09f9206e8c0f6aa1e315104b3
    }
    return self;
}

#pragma mark - Init and Dealloc
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    if (self.setupBlock)
        self.setupBlock(self);

}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Orientation
- (void)didRotate {
    NSTimeInterval duration = 0.4;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        duration = 0.3;
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.picker setNeedsUpdateConstraints];
        [self.picker layoutIfNeeded];
    }
    
    [self.view.superview setNeedsUpdateConstraints];
    __weak RMPickerViewController *blockself = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [blockself.view.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Properties
- (UIView *)contentView {
    return self.picker;
}

@end
