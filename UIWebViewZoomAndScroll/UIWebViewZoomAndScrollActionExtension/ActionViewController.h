//
//  ActionViewController.h
//  UIWebViewZoomAndScrollActionExtension
//
//  Created by Matthias Gansrigler on 29.01.2015.
//  Copyright (c) 2015 Eternal Storms Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionViewController : UIViewController <UIWebViewDelegate>

//LOOK FOR - (void)webViewDidFinishLoad:(UIWebView *)webView IN THE IMPLEMENTATION FILE TO SEE WHERE THE ACTUAL ZOOMING AND SCROLLING HAPPENS

@property (strong) IBOutlet UIWebView *webView; //connected the outlet to the MainInterface.storyboard, also made this class the delegate of the UIWebView

//these will be delivered from the Action.js Java Script
@property (assign) NSInteger _pageXOffset;
@property (assign) NSInteger _pageYOffset;
@property (assign) CGFloat _pageScale;

@end
