//
//  OCViewController.m
//  VehicleKeyboardDemo
//
//  Created by 杨志豪 on 2018/7/24.
//  Copyright © 2018年 yangzhihao. All rights reserved.
//

#import "OCViewController.h"
#import "VehicleKeyboard_swift-Swift.h"

@interface OCViewController ()<PWHandlerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (weak, nonatomic) IBOutlet UIButton *mynewEnergyButton;

@property (strong,nonatomic) PWHandler *handler;

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.handler = [PWHandler new];
    
    self.handler.delegate = self;
    //改变主题色
//    self.handler.mainColor = [UIColor redColor];
    //UITextField绑定车牌键盘(输入框形式)
    [self.myTextField changeToPlatePWKeyBoardInpurView];
    
    //UICollectionView绑定车牌键盘(格子形式)
    [self.handler setKeyBoardViewWithCollectionView:self.collectionView];
}

//隐藏键盘
- (IBAction)hiddenButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//切换新能源车牌
- (IBAction)changeModeButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    //uitextField输入框改变新能源
    [self.myTextField changePlateInputTypeWithIsNewEnergy:sender.selected];
    
    //格子输入框改变新能源
    [self.handler changeInputTypeWithIsNewEnergy:sender.selected];
}


- (IBAction)setCollectionInputButtonAction:(UIButton *)sender {
    self.mynewEnergyButton.selected = NO;
    [self.handler setPlateWithPlate:@"湘JR0001" type:PWKeyboardNumTypeAuto];
}

- (IBAction)setTextFieldPlateButtonAction:(UIButton *)sender {
    self.mynewEnergyButton.selected = NO;
    [self.myTextField setPlateWithPlate:@"粤BR0001" type:PWKeyboardNumTypeAuto];
}

#pragma mark - PWHandlerDelegate
- (void)palteDidChnageWithPlate:(NSString *)plate complete:(BOOL)complete{
    NSLog(@"输入车牌号为:%@ \n 是否完整：%@",plate,complete ? @"完整" : @"不完整");
}

- (void)plateInputCompleteWithPlate:(NSString *)plate{
    NSLog(@"输入完成。车牌号为:%@",plate);
}

- (void)plateKeyBoardShow{
    NSLog(@"键盘显示了");
}

- (void) plateKeyBoardHidden{
    NSLog(@"键盘隐藏了");
}



@end
