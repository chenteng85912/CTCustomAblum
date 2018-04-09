//
//  ViewController.m
//  TYKYLibrary
//
//  Created by Apple on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "CTONEPhoto.h"
#import "CTCustomAlbum.h"

#define ImageCollectionIdentifier @"ImageCollectionIdentifier"

#define CELL_WIDTH    [[UIScreen mainScreen] bounds].size.width/3

@interface ViewController ()<CTONEPhotoDelegate,CTSendPhotosProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *colView;
@property (strong, nonatomic) NSArray<UIImage *> *imagesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ImageCollectionIdentifier];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}
- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag==1){//系统相册
        [CTONEPhoto openAlbum:CTShowAlbumImageModel enableEdit:NO photoComplete:^(UIImage *image, NSString *imageName) {
            self.imagesArray = @[image];
            
            [self.colView reloadData];
        } videoComplete:nil];
//        [CTONEPhoto openAlbum:CTShowAlbumImageModel withDelegate:self enableEdit:NO];

    }else if(sender.tag==2){//系统相机
//        [CTONEPhoto openCameraWithDelegate:self enableEdit:NO];
        [CTONEPhoto openCamera:NO photoComplete:^(UIImage *image, NSString *imageName) {
            self.imagesArray = @[image];
            
            [self.colView reloadData];
        }];
        
    }else{//自定义相册
//        [CTCustomAlbum showCustomAlbumWithDelegate:self];
        [CTCustomAlbum showCustomAlbumWithBlock:^(NSArray<UIImage *> *imagesArray) {
            self.imagesArray = imagesArray;
            
            [self.colView reloadData];
        }];
      
    }
}
    
#pragma mark CTONEPhotoDelegate
- (void)sendOnePhoto:(UIImage *)image withImageName:(NSString *)imageName
{
    self.imagesArray = @[image];

    [self.colView reloadData];
}

- (void)sendMediaUrl:(NSString *)url fileName:(NSString *)fileName thumeImg:(UIImage *)img{
    self.imagesArray = @[img];
    [self.colView reloadData];
}

#pragma mark CTCustomAlbumViewControllerDelegate
//传出图片数组
- (void)sendImageArray:(NSMutableArray <UIImage *> *)imgArray{
    self.imagesArray = imgArray;
    [self.colView reloadData];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionIdentifier forIndexPath:indexPath];

    [mycell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = self.imagesArray[indexPath.row];
    imgView.clipsToBounds = YES;
    [mycell.contentView addSubview:imgView];
    
    return mycell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
    
}

@end