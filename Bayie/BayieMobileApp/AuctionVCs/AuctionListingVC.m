//
//  AuctionListingVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/17/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "Auction.h"
#import "AuctionListingVC.h"
#import "CustomCategoryCollectionViewCell.h"

@interface AuctionListingVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *auctionArray;
@property (nonatomic, assign) CGFloat categoryCellHeight;
@end

@implementation AuctionListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.auctionArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    long row = [indexPath row];
    
    Auction *auct = [self.auctionArray objectAtIndex:indexPath.row];
    static NSString *catCellidentifier = @"CatCell";
    CustomCategoryCollectionViewCell *catCell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:catCellidentifier
                                                 forIndexPath:indexPath];
    catCell.layer.borderWidth=1.0f;
    //border color
    catCell.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    catCell.auct = [self.auctionArray objectAtIndex:row];
    
    // Clean cell for re-use
//    catCell.categoryImage.image = [[UIImage alloc] init];
//
//    NSString *url_Img = [catDataDict valueForKey:@"mobile_icon"];
//    NSString *url_Img_FULL;
//
//    if (url_Img == (id)[NSNull null]) {
//        url_Img_FULL = catbase_defaultimageUrl;
//    } else {
//        url_Img_FULL = [catbase_imageUrl stringByAppendingPathComponent:url_Img];
//    }
//    catCell.categoryImage.image = nil;
//    [catCell.categoryImage sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    return catCell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIEdgeInsetsMake(0, 0,0, 0);
    }
    return UIEdgeInsetsMake(0, 0,0, 0); // top, left, bottom, right
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        float horizontalGap = 8.0;
        if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation] )){
            _categoryCellHeight = 250 ;
            CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - horizontalGap*7)/6;
            CGSize cellSize = CGSizeMake(cellWidth,cellWidth);
            return cellSize;
            
        }
        _categoryCellHeight = 398;
        CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - horizontalGap*4)/3;
        CGSize cellSize = CGSizeMake(cellWidth,cellWidth);
        return cellSize;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
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
