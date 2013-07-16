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
    
    self.onePageView.numberOfPage = 8;
    
    UIView *color = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    color.backgroundColor = [UIColor blueColor];
    UIImageView *bg_menu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg2"]];
    UIImageView *bg_menu_frame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg2_frame"]];
    UIImageView *menuItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg1"]];
    
    [self.onePageView actionItemWithView:bg_menu AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 0, 0.0f, 0.0f);
        } else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition, 0.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth, 0.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition > self.onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    [self.onePageView actionItemWithView:menuItem AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth) {
            if (relativePosition < 0) {
                return CATransform3DTranslate(transform, 43.0, 58.0f, 0.0f);
            } else
                return CATransform3DTranslate(transform, relativePosition + relativePosition * 203.0 / self.onePageView.windowWidth + 43.0, 58.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth + 246.0, 58.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition > self.onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    [self.onePageView actionItemWithView:bg_menu_frame AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 0, 0.0f, 0.0f);
        } else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition, 0.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth, 0.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition > self.onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 1.0;
    }];
    
    UIImageView *circle1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_highlight"]];
    [self.onePageView actionItemWithView:circle1 AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 27.0, 44.0f, 0.0f);
        } else
            return CATransform3DTranslate(transform, relativePosition + 27.0, 44.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return 1;
        }
        else if (relativePosition < self.onePageView.windowWidth * .3) {
            return 1.0 - (relativePosition - self.onePageView.windowWidth * 0) / (self.onePageView.windowWidth * 0.3);
        }
        else
            return 0.0;
    }];
    
    /////////////////////
    
    UIImageView *bg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg3"]];
    [self.onePageView actionItemWithView:bg3 AtPage:2 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 0, 0.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth, 0.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition >= self.onePageView.windowWidth * -1
            && relativePosition <= self.onePageView.windowWidth * 2) {
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
    [self.onePageView actionItemWithView:action3 AtPage:2 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 24.0, 112.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition + 24.0, 112.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth + 24.0, 112.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -0.5) {
            return 0;
        }
        else if (relativePosition < 0) {
            return 1.0 * (relativePosition - self.onePageView.windowWidth * -0.5) / (self.onePageView.windowWidth * 0.5);
        }
        else if (relativePosition <= self.onePageView.windowWidth * 0.5) {
            return 1.0 - (relativePosition - 0) / (self.onePageView.windowWidth * 0.5);
        }
        else if (relativePosition <= self.onePageView.windowWidth * 2) {
            return 0.0;
        }
        else
            return 0.0;
    }];

    
    UIImageView *blueflag3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueflag"]];
    [self.onePageView actionItemWithView:blueflag3 AtPage:2 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 48.0, 127.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth * .1) {
            return CATransform3DTranslate(transform, relativePosition + 48.0, 127.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth * .5) {/// 160  280
            CGFloat ratio = (relativePosition - self.onePageView.windowWidth * .1) / (self.onePageView.windowWidth * 0.4);
            return CATransform3DTranslate(transform,
                                          relativePosition + ratio * 112.0 + 48.0,
                                          ratio * 153.0 + 127.0f,
                                          0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition + 160.0, 280.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth + 160.0, 280.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return 0;
        }
        else if (relativePosition <= self.onePageView.windowWidth * .5) {
            return 1.0 * (relativePosition - 0) / (self.onePageView.windowWidth * 0.5);
        }
        else if (relativePosition <= self.onePageView.windowWidth * .8) {
            return 1.0;
        }
        else if (relativePosition <= self.onePageView.windowWidth) {
            return 1.0 - (relativePosition - self.onePageView.windowWidth * .8) / (self.onePageView.windowWidth * 0.2);
        }
        else
            return 0.0;
    }];
    
    UIImageView *bg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg4"]];
    [self.onePageView actionItemWithView:bg4 AtPage:3 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return CATransform3DTranslate(transform, self.onePageView.windowWidth * -1, 0.0f, 0.0f);
        }
        else if (relativePosition < 0) {
            return CATransform3DTranslate(transform, relativePosition, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, 0, 0.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -.2) {
            return 0.0;
        }
        else if (relativePosition < 0) {
            return 1.0 * (relativePosition - self.onePageView.windowWidth * -.2) / (self.onePageView.windowWidth * 0.2);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    
    UIImageView *bg5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg5"]];
    [self.onePageView actionItemWithView:bg5 AtPage:4 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 0, 0.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth * 2) {
            return CATransform3DTranslate(transform, relativePosition, 0.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth * 2, 0.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return 0;
        }
        else if (relativePosition < self.onePageView.windowWidth * 3) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    UIImageView *circle5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_highlight"]];
    [self.onePageView actionItemWithView:circle5 AtPage:4 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return CATransform3DTranslate(transform, 239.0, 47.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return CATransform3DTranslate(transform, relativePosition + 239.0, 47.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, self.onePageView.windowWidth + 239.0, 47.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < 0) {
            return 0;
        }
        else if (relativePosition < self.onePageView.windowWidth * .1) {
            return 1;
        }
        else if (relativePosition < self.onePageView.windowWidth * .3) {
            return 1.0 - (relativePosition - self.onePageView.windowWidth * .1) / (self.onePageView.windowWidth * 0.2);
        }
        else
            return 0.0;
    }];
    
    UIImageView *teachoutput = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_output.png"]];
    [self.onePageView actionItemWithView:teachoutput AtPage:5 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return CATransform3DTranslate(transform, 43.0, 397.0f, 0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth * -.7) {
            return CATransform3DTranslate(transform, relativePosition + 43.0, 397.0f, 0.0f);
        }
        else if (relativePosition < 0) {
            CGFloat ratio = (relativePosition - self.onePageView.windowWidth * -.7) / (self.onePageView.windowWidth * 0.7);
            return CATransform3DTranslate(transform,
                                          relativePosition + 43.0,
                                          ratio * -112.0f + 397.0f,
                                          0.0f);
        }
        else if (relativePosition < self.onePageView.windowWidth * .5) {
            CGFloat ratio = (relativePosition) / (self.onePageView.windowWidth * 0.5);
            return CATransform3DTranslate(transform,
                                          relativePosition + 43.0,
                                          ratio * 112.0f + 285.0f,
                                          0.0f);
        }
        else
            return CATransform3DTranslate(transform,  43.0, 397.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -.7) {
            return 0;
        }
        else if (relativePosition < 0) {
            return 1.0 * (relativePosition - self.onePageView.windowWidth * -.7) / (self.onePageView.windowWidth * 0.7);
        }
        else if (relativePosition < self.onePageView.windowWidth * .5) {
            return 1.0 - (relativePosition) / (self.onePageView.windowWidth * 0.5);
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
    
    
    [self.onePageView actionItemWithView:rotateView AtPage:6 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return CATransform3DTranslate(transform, self.onePageView.windowWidth * -1 + 65.0f, 230.0f, 0.0f);
        }
        else if (relativePosition < 0) {
            return CATransform3DTranslate(transform, relativePosition + 65.0f, 230.0f, 0.0f);
        }
        else
            return CATransform3DTranslate(transform, 0 + 65.0f, 230.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return 0;
        }
        else if (relativePosition < self.onePageView.windowWidth * -.5) {
            return 1.0 * (relativePosition - self.onePageView.windowWidth * -1) / (self.onePageView.windowWidth * 0.5);
        }
        else if (relativePosition < self.onePageView.windowWidth) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    
    UIImageView *bg6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_bg6"]];
    [self.onePageView actionItemWithView:bg6 AtPage:7 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        return CATransform3DRotate(CATransform3DTranslate(transform, 0, 0.0f, 0.0f), 0, 0, 0.0, 1.0);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        if (relativePosition < self.onePageView.windowWidth * -1) {
            return 0;
        }
        else if (relativePosition < self.onePageView.windowWidth * 2) {
            return 1.0;
        }
        else
            return 0.0;
    }];
    
    UIImageView *noteAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teach_board"]];
    [self.onePageView actionItemWithView:noteAlert AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        return CATransform3DTranslate(transform, relativePosition, 397.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        return 1.0;
    }];
    
    int dot_space = 12;
    CGSize dotSize = CGSizeMake(2, 2);
    UIView *dotContanter = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, (self.onePageView.numberOfPage - 1) * dot_space + dotSize.width, dotSize.height))];
    for (int i = 0; i < self.onePageView.numberOfPage; ++i) {
        /// 12 = 2 + 10;
        UIImageView *dotnotImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot_not"]];
        f = dotnotImg.frame;
        f.origin.x = i * dot_space;
        dotnotImg.frame = f;
        [dotContanter addSubview:dotnotImg];
    }
    
    [self.onePageView actionItemWithView:dotContanter AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        return CATransform3DTranslate(transform, relativePosition + 160.0 - dotContanter.frame.size.width / 2, 462.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        return 0.3;
    }];

    
    UIImageView *dotImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
    [self.onePageView actionItemWithView:dotImg AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        CGFloat nowX = relativePosition + 160.0 - dotContanter.frame.size.width / 2;
        nowX += self.onePageView.currentItemIndex * dot_space;
        return CATransform3DTranslate(transform, nowX, 462.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        return 1.0;
    }];

    
    UILabel *alertText = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 300, 50))];
    alertText.textColor = [UIColor whiteColor];
    alertText.textAlignment = UITextAlignmentCenter;
    alertText.minimumScaleFactor = 0.5;
    alertText.adjustsFontSizeToFitWidth = YES;
    alertText.minimumFontSize = 7.0;
    alertText.font = [UIFont systemFontOfSize:15.0];
    alertText.backgroundColor = [UIColor clearColor];
    [self.onePageView actionItemWithView:alertText AtPage:0 withAction:^CATransform3D(CATransform3D transform, CGFloat relativePosition) {
        alertText.text = [NSString stringWithFormat:@"%d", self.onePageView.currentItemIndex];
        return CATransform3DTranslate(transform, relativePosition + 10, 412.0f, 0.0f);
    } andAlpha:^CGFloat(CGFloat currentAlpha, CGFloat relativePosition) {
        return 1.0;
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
