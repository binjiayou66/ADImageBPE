//
//  ViewController.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ViewController.h"
#import "ADImageBPE/ADImageBPE.h"

typedef NS_ENUM(NSUInteger, ViewControllerButtonTag) {
    ViewControllerButtonTagBrowserImage = 100,
    ViewControllerButtonTagBrowserPath,
    ViewControllerButtonTagBrowserURL,
    ViewControllerButtonTagPicker,
    ViewControllerButtonTagEditor,
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *titles = @[@"Browser - Image", @"Browser - Path", @"Browser - URL", @"Picker", @"Editor"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120 + i * 64, self.view.bounds.size.width, 44)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor blueColor];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    for (int i = 0; i < 4; i++) {
        CGFloat width = self.view.bounds.size.width / 4 - 10;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5 + i * (width + 5), self.view.bounds.size.height - width - 30, width, width)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        iv.tag = 1000 + i;
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [iv addGestureRecognizer:tap];
        [self.view addSubview:iv];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    NSArray *images = @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"], [UIImage imageNamed:@"3.jpg"], [UIImage imageNamed:@"4.jpg"],];
    ADImageBrowserController *b = [[ADImageBrowserController alloc] initWithImages:images fromFrame:tap.view.frame currentIndex:tap.view.tag - 1000];
    [self presentViewController:b animated:NO completion:nil];
}

- (void)onButtonClicked:(UIButton *)button
{
    switch (button.tag) {
        case ViewControllerButtonTagBrowserImage:
        {
            NSArray *images = @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"], [UIImage imageNamed:@"3.jpg"], [UIImage imageNamed:@"4.jpg"],];
            ADImageBrowserController *b = [[ADImageBrowserController alloc] initWithImages:images];
            [self presentViewController:b animated:YES completion:nil];
            break;
        }
        case ViewControllerButtonTagBrowserPath:
        {
            break;
        }
        case ViewControllerButtonTagBrowserURL:
        {
            break;
        }
        case ViewControllerButtonTagPicker:
        {
            break;
        }
        case ViewControllerButtonTagEditor:
        {
            break;
        }
        default:
            break;
    }
}

@end
