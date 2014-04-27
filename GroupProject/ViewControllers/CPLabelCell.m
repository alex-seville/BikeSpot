//
//  CPLabelCell.m
//  GroupProject
//
//  Created by Eugenia Leong on 4/26/14.
//  Copyright (c) 2014 CodePath Group Project. All rights reserved.
//

#import "CPLabelCell.h"

@implementation CPLabelCell

- (void)awakeFromNib
{
    // Initialization code
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
