//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"
#import "HPGrowingTextView.h"

static const CGFloat labelPadding = 10;
static const CGFloat textViewPadding = 5;

// Private
@interface MWCaptionView () {
    id <MWPhoto> _photo;
    UILabel *_label;
    bool _isEditable;
}
@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo  isEditable:(bool)isEditable {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        self.userInteractionEnabled = NO;
        _photo = photo;
        _isEditable = isEditable;
        self.userInteractionEnabled = _isEditable;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = [UIColor whiteColor];
        self.barStyle = UIBarStyleBlackTranslucent;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self setupCaption];
    }
    return self;
}
- (CGSize)sizeThatFits:(CGSize)size {
    static CGSize maxSize = {0, 0};
    int numLines = _textView.internalTextView.contentSize.height/_textView.font.lineHeight;
    if (numLines > _textView.maxNumberOfLines) {
        if (CGSizeEqualToSize(maxSize, CGSizeZero) == true)
        return maxSize;
    } else {
        
    }
    CGFloat maxHeight = 9999;
    if (numLines > 0) maxHeight = _textView.font.leading*numLines;
    CGSize textSize = [_textView.text boundingRectWithSize:CGSizeMake(size.width, maxHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:_textView.font}
                                                   context:nil].size;
    CGSize size1 = CGSizeMake(size.width, textSize.height + 10);
    if (numLines == _textView.maxNumberOfLines) {
        maxSize = size1;
    }
    return size1;

}

- (void)setupCaption {
    if (_isEditable == YES) {
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))];
        _textView.minHeight = self.bounds.size.height;
        _textView.maxNumberOfLines = 3;
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 2, 5, 0);
        _textView.placeholder = @"Message";
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
        _textView.textColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.userInteractionEnabled = YES;
        _textView.returnKeyType = UIReturnKeyDone;
        if ([_photo respondsToSelector:@selector(caption)]) {
            _textView.text = [_photo caption] ? [_photo caption] : @"";
        }
        [_textView setNeedsDisplay];
        [self addSubview:_textView];
        [_textView sizeToFit]; //added
        [_textView layoutIfNeeded];
    } else {
        _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                          self.bounds.size.width-labelPadding*2,
                                                                          self.bounds.size.height))];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _label.opaque = NO;
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        
        _label.numberOfLines = 0;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:17];
        if ([_photo respondsToSelector:@selector(caption)]) {
            _label.text = [_photo caption] ? [_photo caption] : @" ";
        }
        [self addSubview:_label];
    }
}

@end
