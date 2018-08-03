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


@property (weak, nonatomic) IBOutlet UIView *plateInputView;

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (weak, nonatomic) IBOutlet UIButton *mynewEnergyButton;

@property (strong,nonatomic) PWHandler *handler;

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UITextField绑定车牌键盘(输入框形式)
    [self.myTextField changeToPlatePWKeyBoardInpurView];
    
    //UICollectionView绑定车牌键盘(格子形式)
    self.handler = [PWHandler new];
    [self.handler setKeyBoardViewWithView:self.plateInputView];
    
    self.handler.delegate = self;
//    改变主题色
//    self.handler.mainColor = [UIColor redColor];
//    改变文字大小
//    self.handler.textFontSize = 18;
//    改变文字颜色
//    self.handler.textColor = [UIColor greenColor];
    
    
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

//车牌输入发生变化时的回调
- (void)palteDidChnageWithPlate:(NSString *)plate complete:(BOOL)complete{
    NSLog(@"输入车牌号为:%@ \n 是否完整：%@",plate,complete ? @"完整" : @"不完整");
}

//输入完成点击确定后的回调
- (void)plateInputCompleteWithPlate:(NSString *)plate{
    NSLog(@"输入完成。车牌号为:%@",plate);
}

//车牌键盘出现的回调
- (void)plateKeyBoardShow{
    NSLog(@"键盘显示了");
}

//车牌键盘消失的回调
- (void) plateKeyBoardHidden{
    NSLog(@"键盘隐藏了");
}



@end
