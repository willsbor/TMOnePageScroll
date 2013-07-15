//
//  TMOPSViewController.m
//  TMOnePageScroll
//
//  Created by willsborKang on 13/7/14.
//  Copyright (c) 2013年 thinkermobile. All rights reserved.
//

#import "TMOPSViewController.h"

#import "TMOnePageView.h"
#import "TMOPActionItem.h"

@interface TMOPSViewController ()

@end

@implementation TMOPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.onePageView.numberOfPage = 3;
    
    UIView *color = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    color.backgroundColor = [UIColor blueColor];
    UIImageView *bg_menu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg2"]];
    UIImageView *bg_menu_frame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg2_frame"]];
    UIImageView *menuItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg1"]];
    
    TMOPActionItem *bgMenuAction = [self.onePageView actionItemWithView:bg_menu];
    [bgMenuAction setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth) {
            return CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, onePageView.windowWidth, 0.0f, 0.0f);
        
    }];
    [bgMenuAction setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark > onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    TMOPActionItem *menuItemAction = [self.onePageView actionItemWithView:menuItem];
    [menuItemAction setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth) {
            
            /// 246
            return CATransform3DTranslate(transform, onePageView.positionMark + onePageView.positionMark * 203.0 / onePageView.windowWidth + 43.0, 58.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, onePageView.windowWidth + 246.0, 58.0f, 0.0f);
        
    }];
    [menuItemAction setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark > onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    TMOPActionItem *bgMenuFrameAction = [self.onePageView actionItemWithView:bg_menu_frame];
    [bgMenuFrameAction setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth) {
            return CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, onePageView.windowWidth, 0.0f, 0.0f);
        
    }];
    [bgMenuFrameAction setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark > onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    /////////////////////
    
    UIImageView *bg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg3"]];
    TMOPActionItem *bg3Action = [self.onePageView actionItemWithView:bg3];
    [bg3Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 2, 0.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 3, 0.0f, 0.0f);
        
    }];
    [bg3Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark >= onePageView.windowWidth * 1
            && onePageView.positionMark <= onePageView.windowWidth * 4) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    UIImageView *circle3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_highlight"]];
    UIImageView *arrow3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_arrow"]];
    UIView *action3 = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 90, 130))];
    [action3 addSubview:circle3];
    CGRect f = arrow3.frame;
    f.origin = CGPointMake(36, 66);
    arrow3.frame = f;
    [action3 addSubview:arrow3];
    TMOPActionItem *circle3Action = [self.onePageView actionItemWithView:action3];
    [circle3Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 2 + 24.0, 112.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return CATransform3DTranslate(transform, onePageView.positionMark + 24.0, 112.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 3 + 24.0, 112.0f, 0.0f);
        
    }];
    [circle3Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        
        if (onePageView.positionMark < onePageView.windowWidth * 1.5) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return 1.0 * (onePageView.positionMark - onePageView.windowWidth * 1.5) / (onePageView.windowWidth * 0.5);
        }
        else if (onePageView.positionMark <= onePageView.windowWidth * 2.5) {
            return 1.0 - (onePageView.positionMark - onePageView.windowWidth * 2) / (onePageView.windowWidth * 0.5);
        }
        else if (onePageView.positionMark <= onePageView.windowWidth * 4) {
            return 0.0;
        }
        else
            return 0.0;
    }];
    
    UIImageView *blueflag3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueflag"]];
    TMOPActionItem *blueflag3Action = [self.onePageView actionItemWithView:blueflag3];
    [blueflag3Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 2 + 48.0, 127.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 2.1) {
            return CATransform3DTranslate(transform, onePageView.positionMark + 48.0, 127.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 2.5) {/// 160  280
            CGFloat ratio = (onePageView.positionMark - onePageView.windowWidth * 2.1) / (onePageView.windowWidth * 0.4);
            return CATransform3DTranslate(transform,
                                          onePageView.positionMark + ratio * 112.0 + 48.0,
                                          ratio * 153.0 + 127.0f,
                                          0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return CATransform3DTranslate(transform, onePageView.positionMark + 160.0, 280.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 3 + 160.0, 280.0f, 0.0f);
        
    }];
    [blueflag3Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        
        if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return 0;
        }
        else if (onePageView.positionMark <= onePageView.windowWidth * 2.5) {
            return 1.0 * (onePageView.positionMark - onePageView.windowWidth * 2) / (onePageView.windowWidth * 0.5);
        }
        else if (onePageView.positionMark <= onePageView.windowWidth * 2.6) {
            return 1.0;
        }
        else if (onePageView.positionMark <= onePageView.windowWidth * 3) {
            return 1.0 - (onePageView.positionMark - onePageView.windowWidth * 2.6) / (onePageView.windowWidth * 0.4);
        }
        else
            return 0.0;
    }];
    
    UIImageView *bg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg4"]];
    TMOPActionItem *bg4Action = [self.onePageView actionItemWithView:bg4];
    [bg4Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 2) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 2, 0.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 3, 0.0f, 0.0f);
        
    }];
    [bg4Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 2.6) {
            return 0.0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return 1.0 * (onePageView.positionMark - onePageView.windowWidth * 2.6) / (onePageView.windowWidth * 0.4);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 4) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    
    UIImageView *bg5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg5"]];
    TMOPActionItem *bg5Action = [self.onePageView actionItemWithView:bg5];
    [bg5Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 4) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 4, 0.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 6) {
            return CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 6, 0.0f, 0.0f);
        
    }];
    [bg5Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 3) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 7) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    
    TMOPActionItem *circle5Action = [self.onePageView actionItemWithView:circle3];
    [circle5Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 4) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 4 + 239.0, 47.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5) {
            return CATransform3DTranslate(transform, onePageView.positionMark + 239.0, 47.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 5 + 239.0, 47.0f, 0.0f);
        
    }];
    [circle5Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 4) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 4.1) {
            return 1;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 4.3) {
            return 1.0 - (onePageView.positionMark - onePageView.windowWidth * 4.1) / (onePageView.windowWidth * 0.2);
        }
        else
            return 0.0;
    }];
    
    UIImageView *teachoutput = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_output.png"]];
    TMOPActionItem *teachoutputAction = [self.onePageView actionItemWithView:teachoutput];
    [teachoutputAction setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 4) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 4 + 43.0, 397.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 4.3) {
            return CATransform3DTranslate(transform, onePageView.positionMark * 4 + 43.0, 397.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5) {
            CGFloat ratio = (onePageView.positionMark - onePageView.windowWidth * 4.3) / (onePageView.windowWidth * 0.7);
            return CATransform3DTranslate(transform,
                                          onePageView.positionMark + 43.0,
                                          ratio * -112.0f + 397.0f,
                                          0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5.5) {
            CGFloat ratio = (onePageView.positionMark - onePageView.windowWidth * 5) / (onePageView.windowWidth * 0.5);
            return CATransform3DTranslate(transform,
                                          onePageView.positionMark + 43.0,
                                          ratio * 112.0f + 285.0f,
                                          0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 5 + 43.0, 397.0f, 0.0f);
        
    }];
    [teachoutputAction setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 4.3) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5) {
            return 1.0 * (onePageView.positionMark - onePageView.windowWidth * 4.3) / (onePageView.windowWidth * 0.7);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5.5) {
            return 1.0 - (onePageView.positionMark - onePageView.windowWidth * 5) / (onePageView.windowWidth * 0.5);
        }
        else
            return 0.0;
    }];
    
    
    UIView *rotateView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 181, 80))];
    UIImageView *rotateAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_irotate_con"]];
    UIImageView *rotateArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_totate"]];
    f = rotateArrow.frame;
    f.origin.y = (rotateView.frame.size.height - rotateArrow.frame.size.height) / 2;
    rotateArrow.frame = f;
    [rotateView addSubview:rotateArrow];
    f = rotateAlert.frame;
    f.origin.x = (rotateView.frame.size.width - rotateAlert.frame.size.width) / 2;
    rotateAlert.frame = f;
    [rotateView addSubview:rotateAlert];
    
    
    TMOPActionItem *rotateAction = [self.onePageView actionItemWithView:rotateView];
    [rotateAction setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 5) {
            return CATransform3DTranslate(transform, onePageView.windowWidth * 5 + 65.0f, 230.0f, 0.0f);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 6) {
            return CATransform3DTranslate(transform, onePageView.positionMark + 65.0f, 230.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, onePageView.windowWidth * 6 + 65.0f, 230.0f, 0.0f);
        
    }];
    [rotateAction setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 5) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 5.5) {
            return 1.0 * (onePageView.positionMark - onePageView.windowWidth * 5) / (onePageView.windowWidth * 0.5);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 7) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    
    UIImageView *bg6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg6"]];
    TMOPActionItem *bg6Action = [self.onePageView actionItemWithView:bg6];
    [bg6Action setActionBlock:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {
        
        if (onePageView.positionMark < onePageView.windowWidth * 7) {
            return CATransform3DRotate(CATransform3DTranslate(transform, onePageView.windowWidth * 7, 0.0f, 0.0f), 0, 0, 0.0, 1.0);
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 8) {
            return CATransform3DRotate(CATransform3DTranslate(transform, onePageView.positionMark, 0.0f, 0.0f), -0, 0, 0.0, 1.0);
        }
        else
            return CATransform3DRotate(CATransform3DTranslate(transform, onePageView.windowWidth * 8, 0.0f, 0.0f), -0, 0, 0.0, 1.0);
        
    }];
    [bg6Action setAlphaBlock:^CGFloat(CGFloat currentAlpha, TMOnePageView *onePageView) {
        if (onePageView.positionMark < onePageView.windowWidth * 6) {
            return 0;
        }
        else if (onePageView.positionMark < onePageView.windowWidth * 9) {
            return 1.0;
        }
        else
            return 0.0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOnePageView:nil];
    [super viewDidUnload];
}
@end
