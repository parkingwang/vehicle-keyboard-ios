//
//  ViewController.m
//  PWKeyboardDemo
//
//  Created by fzy on 2017/11/13.
//  Copyright © 2017年 fzy. All rights reserved.
//

#import "ViewController.h"
#import "PWKeyboardView.h"
#import "TestCollectionViewCell.h"

#import "PWHandler.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign, nonatomic) NSInteger type;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) PWHandler * handler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof (self)weakSelf = self;
    self.textField.inputView = [PWKeyboardView shareInstance];
    [PWKeyboardView shareInstance].selectedColor = [UIColor greenColor];
    [PWKeyboardView shareInstance].type = PWKeyBoardTypeCivilAndArmy;
    [PWKeyboardView shareInstance].buttonClickBlock = ^(PWKeyboardButtonType buttonType, NSString *text) {
        switch (buttonType) {
                //当键位类型为确定时，收回键盘
            case PWKeyboardButtonTypeDone:
                [weakSelf.textField resignFirstResponder];
                break;
            default:
                //改变textField的text
                [weakSelf.textField changetext:text];
                //将对应的改动传递给js，使键盘的刷新获取对应的键位
                [[PWKeyboardView shareInstance] setPlate:weakSelf.textField.text type:[PWKeyboardView shareInstance].type index:[weakSelf.textField offsetFromPosition:weakSelf.textField.beginningOfDocument toPosition:weakSelf.textField.selectedTextRange.start]];
                break;
        }
    };
    
    //self.handler = [[PWHandler alloc] initWithReuseIdentifier:NSStringFromClass(PWSegmentCollectionViewCell.class)];
    //实例化PWHandler，同时注册UICollectionViewCell，此cell需要继承PWSegmentCollectionViewCell，供使用者自定义样式
    self.handler = [[PWHandler alloc] initWithReuseIdentifier:NSStringFromClass(TestCollectionViewCell.class)];
    //设置PWHandler中UICollectionView的应用，在PWHandler实现中用于UICollectionView的相关操作
    self.handler.collectionView = self.collectionView;
    //PWHandler中(NSString *)plate提供车牌号的主动设置，可也用此属性过去当前的车牌号
    //self.handler.plate = @"京2345678910101";
    //使用者自己提供的UICollectionView，仅需注册UICollectionViewCell，同时将代理引用与PWHandler关联
    [self.collectionView registerClass:TestCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(TestCollectionViewCell.class)];
    self.collectionView.delegate = self.handler;
    self.collectionView.dataSource = self.handler;
    self.collectionView.clipsToBounds = NO;
}

- (IBAction)changeKeyboardType:(UIButton *)sender {
    static NSInteger i = 0;
    //    [[PWPlateKeyBoardWindow shareInstance] setPlate:self.textField.text type:self.type index:[self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.selectedTextRange.start]];
    //    [sender setTitle:[NSString stringWithFormat:@"%ld",i%3] forState:UIControlStateNormal];
    i++;
    if (i%2) {
        [self.handler setNumType:PWKeyboardNumTypeNewEnergy];
    } else {
        [self.handler setNumType:PWKeyboardNumTypeAuto];
    }
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
