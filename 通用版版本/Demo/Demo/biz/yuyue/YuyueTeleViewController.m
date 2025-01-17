//
//  YuyueTeleViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-29.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "YuyueTeleViewController.h"
#import "MBSelectView.h"
#import "XMLDictionary.h"
#import "MBIIRequest.h"
#import "SoapHelper.h"
#import "NSDateUtilities.h"
#import "NSDateUtilities.h"
#import "XMLDictionary.h"
@interface YuyueTeleViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField*_nameTF;
    UITextField*_telTF;
    UITextField*_noteTF;
    MBSelectView*_timeSele;
}
@end

@implementation YuyueTeleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"预约信息";
    self.view.backgroundColor=HEX(@"#ffffff");
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewUPloadView)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(backViewUPloadView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }

    
   
    
    
    NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    
    NSDictionary*allUserDic =[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE][moblie];
    
    NSArray *itemArray =@[@"套餐名称:",@"套餐价格:",@"预约时间:",@"姓名:",@"联系电话:",@"备注:"];
    for (int i=0; i<itemArray.count; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 80, 35)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=itemArray[i];
        label.font=kNormalTextFont;
        [self.view addSubview:label];
        if (i==0) {
            NSLog(@"%@",_infoAbout);
            UILabel *value=[[UILabel alloc]initWithFrame:CGRectMake(150, 10+i*40, 170, 35)];
            value.textAlignment=NSTextAlignmentLeft;
            value.text=MBNonEmptyStringNo_(_infoAbout[@"templateName"][@"content"]);
            value.font=kNormalTextFont;
            [self.view addSubview:value];
        }
        if (i==1) {
            UILabel *value=[[UILabel alloc]initWithFrame:CGRectMake(150, 10+i*40, 170, 35)];
            value.textAlignment=NSTextAlignmentLeft;
            value.text=[NSString stringWithFormat:@"￥%@",MBNonEmptyStringNo_(_infoAbout[@"price"][@"content"])];
            value.font=kNormalTextFont;
            [self.view addSubview:value];
        }
        if (i==2) {

            _timeSele =[[MBSelectView alloc]initWithFrame:CGRectMake(150, 15+40*2, 160, 35)];
            _timeSele.dateValue=[[NSDate date]daysLater:1];

            _timeSele.minDate=[[NSDate date]daysLater:1];
            [_timeSele setSelectedDate:[[NSDate date]daysLater:1]];
            _timeSele.selectType=MBSelectTypeDate;
            [self.view addSubview:_timeSele];
            
        }
        if (i==1+2) {
            _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40*2, 160, 35)];
            _nameTF.placeholder=@"请输入预约姓名";
            _nameTF.delegate=self;

            if (![MBNonEmptyStringNo_(allUserDic[@"Name"]) isEqualToString:@""]) {
                _nameTF.text=MBNonEmptyStringNo_(allUserDic[@"Name"]);
            }
            [self.view addSubview:_nameTF];
        }if (i==2+2) {
            _telTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40*2, 160, 35)];
            _telTF.placeholder=@"请输入联系电话";
            _telTF.returnKeyType=UIReturnKeyDone;
            _telTF.keyboardType=UIKeyboardTypeNumberPad;
            _telTF.keyboardAppearance=UIKeyboardAppearanceDefault;//键盘外观
            _telTF.delegate=self;

            if (![MBNonEmptyStringNo_(allUserDic[@"MobileNO"]) isEqualToString:@""]) {
                _telTF.text=MBNonEmptyStringNo_(allUserDic[@"MobileNO"]);
            }

            [self.view addSubview:_telTF];
        }if (i==3+2) {
            _noteTF=[[UITextField alloc]initWithFrame:CGRectMake(160, 10+40+40+40+40*2, 160, 35)];
            _noteTF.placeholder=@"请输入备注";
            _noteTF.delegate=self;
            [self.view addSubview:_noteTF];
        }
    }
 
    for (int i=1; i<5+2; i++) {
        UIImageView *iameg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10+i*38, 300, 1)];
        iameg.backgroundColor=kTipTextColor;
        [self.view addSubview:iameg];
    }
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_red_big_xiayibu.png"] forState:UIControlStateNormal];
    [btn setTitle:@"确定预约" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(yueyuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 200+80, 300, 40);
    [self.view addSubview:btn];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_telTF resignFirstResponder];
}
//确定预约
-(void)yueyuBtnPressed
{
    if (_telTF.text.length!=11) {
        MBAlert(@"手机格式不正确");
        return;
    }
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_infoAbout[@"templateID"][@"content"]),@"appointmentPackageId", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_nameTF.text),@"name", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_telTF.text),@"telphone", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_([_timeSele.dateValue dateString]),@"reservationDate", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(_noteTF.text),@"reservationExplain", nil]];

    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"AddReservationBodycheck"];
    NSLog(@"%@",soapMsg);
    NSLog(@"%@",_infoAbout);
    __block YuyueTeleViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"AddReservationBodycheck" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        [blockSelf AddReservationBodycheckSuccess:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
        
    } failure:^(NSError *error, id JSON) {
       
        [blockSelf AddReservationBodycheckSuccess:@""];

    }];

}
-(void)AddReservationBodycheckSuccess:(NSString *)string
{
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    NSLog(@"1111=====%@",xmlDoc);
    if ([MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"AddReservationBodycheckResponse"][@"AddReservationBodycheckResult"]) isEqualToString:@"1"]) {
        MBAlertWithDelegate(@"预约成功", self);

    }else
    {
        MBAlert(@"未成功预约,请重新预约");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backViewUPloadView];
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
