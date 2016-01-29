//
//  ExamplesContainerViewController.m
//  Examples
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "ExamplesContainerViewController.h"
#import "Examples.h"

@interface ExamplesContainerViewController ()

@end

@implementation ExamplesContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.exampleToLoad) self.title = self.exampleToLoad;

    UIViewController *childViewController = [[NSClassFromString(self.exampleToLoad) alloc] init];
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

@end
