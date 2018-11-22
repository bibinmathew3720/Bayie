//
//  TabBarViewController.m
//  BayieMobileApp
//
//  Created by qbuser on 15/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "TabBarViewController.h"
#import "MyAdsViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLandingScreen) name:@"showLandingScreen" object:nil];
    [self addPostAddBackGroundView:self.view.bounds.size];
    // Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //if(self.selectedIndex == 0){
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navCntlr = (UINavigationController*)self.selectedViewController;
        [navCntlr popToRootViewControllerAnimated:NO];
    }
    //}
    
}

- (void) showLandingScreen {
	if(self.viewControllers.count > 0) {
		UINavigationController *nvc = self.viewControllers[0];
		if([nvc isKindOfClass:[UINavigationController class]]) {
			[nvc popToRootViewControllerAnimated:NO];
		}
	}
	self.selectedIndex = self.viewControllers.count - 1;
    [self pushToMyads];// to navigate myads page on post ad success
}
-(void)pushToMyads{
    MyAdsViewController *myads =  [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsViewController"];
    UINavigationController *nvcProfile = self.viewControllers[self.viewControllers.count - 1];
    [nvcProfile pushViewController:myads animated:true];
}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self addPostAddBackGroundView:size];
}

- (void) addPostAddBackGroundView: (CGSize)size {
  
  
  int itemIndex = 2;
  UIColor* bgColor = [UIColor colorWithRed:(0/255.f) green:(178/255.f) blue:(176/255.f) alpha:1];
  [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:177/255.0 blue:176/255.0 alpha:1]];
  UIView *tmp = [self.tabBar viewWithTag:100001];
  if(tmp) {
    [tmp removeFromSuperview];
  }
  UIView* bgView;
  float itemWidth = size.width / 5.0f; //5 = tab bar items
  if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
    bgView = [[UIView alloc]initWithFrame: CGRectMake(itemWidth * itemIndex , 0,itemWidth, self.tabBar.frame.size.height)];
  } else {
    bgView = [[UIView alloc]initWithFrame: CGRectMake(itemWidth * itemIndex , 0,itemWidth, self.tabBar.frame.size.height)];    // x y w h
  }
  bgView.tag = 100001;
  bgView.backgroundColor = bgColor;
  [self.tabBar insertSubview:bgView atIndex:2];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
