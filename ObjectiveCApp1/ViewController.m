//
//  ViewController.m
//  ObjectiveCApp1
//
//  Created by Hien on 24/05/2022.
//

#import "ViewController.h"
//#import <GTMSessionFetcher/GTMSessionFetcher.h>
//@import FakeGTMSessionFetcherCore;
//@import FakeGTMSessionFetcherFull;
//#import "GTMSessionFetcherCore/GTMSessionFetcher.h";
//#import "FakeGTMSessionFetcherCore/GTMSessionFetcher.h"
#import <FakeGTMSessionFetcher/GTMSessionFetcherLogViewController.h>
@import CasperSDKObjectiveC_GetStateRootHash;
@import CasperSDKObjectiveC_CommonClasses;
@import CasperSDKObjectiveC_GetPeerList;
@import CasperSDKObjectiveC_PutDeploy;
@import CasperSDKObjectiveC_Crypto;
@interface ViewController ()

@end

@implementation ViewController
int counterStateRootHash = 0;
int counterGetPeer = 0;
int counterPutDeploy = 0;
int maxCounter = 50;
-(void)onTick:(NSTimer *)timer {
    GetStateRootHashRPC * item = [[timer userInfo] objectForKey:@"param1"];
    NSString * callID = [[timer userInfo] objectForKey:@"param2"];
    if([item.valueDict[callID] isEqualToString:RPC_VALUE_NOT_SET]) {
        
    } else if([item.valueDict[callID] isEqualToString:RPC_VALUE_ERROR_OBJECT]) {
        NSLog(@"Get state root hash error");
        [timer invalidate];
        timer = nil;
    }else {
        NSLog(@"Find state root hash:%@",item.valueDict[callID]);
        [timer invalidate];
        timer = nil;
    }
    counterStateRootHash ++;
    if(counterStateRootHash == maxCounter) {
        [timer invalidate];
        timer = nil;
    }
}
-(void)onTickPeer:(NSTimer *)timer {
    GetPeerRPC * item = [[timer userInfo] objectForKey:@"param1"];
    NSString * callID = [[timer userInfo] objectForKey:@"param2"];
    if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_NOT_SET]) {
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_ERROR_OBJECT]) {
        NSLog(@"Get peer with parse error");
        [timer invalidate];
        timer = nil;
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_ERROR_NETWORK]) {
        NSLog(@"Get peer with network error");
        [timer invalidate];
        timer = nil;
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALID_RESULT]){
        GetPeerResult * gpr = item.valueDict[callID];
        NSInteger totalPeer = [gpr.PeersMap count];
        NSLog(@"Get Peer result, total peer got:%li",(long)totalPeer);
        int counter = 0;
        for (int i = 0 ; i < 10;i ++) {
            PeerEntry * pe = [[PeerEntry alloc] init];
            pe = [gpr.PeersMap objectAtIndex:i];
            NSLog(@"Peer number %d address:%@ and node id:%@",counter,pe.address,pe.nodeID);
            counter ++;
        }
        [timer invalidate];
        timer = nil;
    }
    counterGetPeer ++;
    if(counterGetPeer == maxCounter) {
        [timer invalidate];
        timer = nil;
    }
}
-(void) getStateRootHash {
    BlockIdentifier * bi = [[BlockIdentifier alloc] init];
    bi.blockType = USE_NONE;
    GetStateRootHashRPC * item = [[GetStateRootHashRPC alloc] init];
    [item initializeWithRPCURL:URL_TEST_NET];
    NSString * jsonString = [bi toJsonStringWithMethodName:CASPER_RPC_METHOD_GET_STATE_ROOT_HASH];
    [item getStateRootHashWithJsonParam:jsonString];
    NSString * callID = @"getStateRootHash1";
    [item getStateRootHashWithJsonParam2:jsonString andCallID:callID];
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval: 1.0
                          target: self
                          selector:@selector(onTick:)
                                                 userInfo: @{@"param1":item,@"param2":callID} repeats:YES];
}
-(void) getPeer {
    GetPeerRPC * getPeerRPC = [[GetPeerRPC alloc] init];
    [getPeerRPC initializeWithRPCURL:URL_TEST_NET];
    GetPeerParam * gpr = [[GetPeerParam alloc] init];
    NSString * json = [gpr generateParamStr];
    NSString * callPeerID = @"getPeerList1";
    [getPeerRPC getPeerResultWithJsonParam2:json andCallID:callPeerID];
    NSTimer * tPeer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                          target: self
                          selector:@selector(onTickPeer:)
                                                 userInfo: @{@"param1":getPeerRPC,@"param2":callPeerID} repeats:YES];
}
-(void) testPutDeploy {
    Deploy * deploy = [[Deploy alloc] init];
    Ed25519Crypto * ed25519 = [[Ed25519Crypto alloc] init];
    bool isEd25519 = false;
    // Setup for Header
    DeployHeader * dh = [[DeployHeader alloc] init];
    NSString * accountEd25519 = @"01d12bf1e1789974fb288ca16fba7bd48e6ad7ec523991c3f26fbb7a3b446c2ea3";
    NSString * accountSecp256k1 = @"0202572ee4c44b925477dc7cd252f678e8cc407da31b2257e70e11cf6bcb278eb04b";
    if(isEd25519) {
        dh.account = accountEd25519;
    } else {
        dh.account = accountSecp256k1;
    }
    dh.timestamp = [ed25519 generateTime];// @"2022-05-22T08:13:49.424Z";
    NSLog(@"Time is:%@",dh.timestamp);
    dh.ttl = @"1h 30m";
    dh.gas_price = 1;
    dh.dependencies = [[NSMutableArray alloc] init];
    //[dh.dependencies addObject:@"0101010101010101010101010101010101010101010101010101010101010101"];
    dh.chain_name = @"casper-test";
    //dh.body_hash = @"798a65dae48dbefb398ba2f0916fa5591950768b7a467ca609a9a631caf13001";
    deploy.header = dh;
    //deploy.itsHash = @"1cdb7d55641a70e19e5fa0293a4e13bb47a55c5838e8935143a054fd23ce1b12";
    // Setup for payment
    ExecutableDeployItem * payment = [[ExecutableDeployItem alloc] init];
    payment.itsType = EDI_MODULEBYTES;
    payment.itsValue = [[NSMutableArray alloc] init];
    ExecutableDeployItem_ModuleBytes * edi_mb = [[ExecutableDeployItem_ModuleBytes alloc] init];
    edi_mb.module_bytes = @"";
    //set up RuntimeArgs with 1 element of NamedArg only
    //setup 1 NamedArgs
    NamedArg * oneNA = [[NamedArg alloc] init];
    oneNA.itsName = @"amount";
    CLValue * oneCLValue = [[CLValue alloc] init];
    CLType * oneCLType = [[CLType alloc] init];
    CLParsed * oneCLParse = [[CLParsed alloc] init];
    oneCLParse.itsValueStr = @"1000000000";
    oneCLParse.itsCLType = [[CLType alloc] init];
    oneCLParse.itsCLType.itsType = CLTYPE_U512;
    oneCLType.itsType = CLTYPE_U512;
    oneCLValue.cl_type = oneCLType;
    oneCLValue.parsed = oneCLParse;
    oneNA.itsCLValue = oneCLValue;
    RuntimeArgs * ra = [[RuntimeArgs alloc] init];
    ra.listArgs = [[NSMutableArray alloc] init];
    [ra.listArgs addObject:oneNA];
    edi_mb.args = ra;
    [payment.itsValue addObject:edi_mb];
    deploy.payment = payment;
    // Deploy session initialization, base on this
     // https://testnet.cspr.live/deploy/f49fbc552914fb3fcbbcf948a613c5413ef3f1afe2c29b9c8aea3ecc89207a8a
     // 1st namedArg
    ExecutableDeployItem * session = [[ExecutableDeployItem alloc] init];
    session.itsType = EDI_TRANSFER;
    session.itsValue = [[NSMutableArray alloc] init];
    ExecutableDeployItem_Transfer * ediSession = [[ExecutableDeployItem_Transfer alloc] init];
    //set up RuntimeArgs with 1 element of NamedArg only
    //setup 1st NamedArgs U512 cltype
    NamedArg * oneNASession = [[NamedArg alloc] init];
    oneNASession.itsName = @"amount";
    CLValue * oneCLValueSession = [[CLValue alloc] init];
    CLType * oneCLTypeSession = [[CLType alloc] init];
    CLParsed * oneCLParseSession = [[CLParsed alloc] init];
    oneCLParseSession.itsValueStr = @"3000000000";
    oneCLParseSession.itsCLType = [[CLType alloc] init];
    oneCLParseSession.itsCLType.itsType = CLTYPE_U512;
    oneCLTypeSession.itsType = CLTYPE_U512;
    oneCLParseSession.itsCLType = oneCLTypeSession;
    oneCLValueSession.cl_type = oneCLTypeSession;
    oneCLValueSession.parsed = oneCLParseSession;
    oneNASession.itsCLValue = oneCLValueSession;
    //setup 2nd NameArg PublicKey cltype
    NamedArg * oneNASession2 = [[NamedArg alloc] init];
    oneNASession2.itsName = @"target";
    CLValue * oneCLValueSession2 = [[CLValue alloc] init];
    CLType * oneCLTypeSession2 = [[CLType alloc] init];
    CLParsed * oneCLParseSession2 = [[CLParsed alloc] init];
    oneCLParseSession2.itsValueStr = @"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a";
    oneCLParseSession2.itsCLType = [[CLType alloc]init];
    oneCLParseSession2.itsCLType.itsType = CLTYPE_PUBLICKEY;
    oneCLTypeSession2.itsType = CLTYPE_PUBLICKEY;
    oneCLParseSession2.itsCLType = oneCLTypeSession2;
    oneCLValueSession2.cl_type = oneCLTypeSession2;
    oneCLValueSession2.parsed = oneCLParseSession2;
    oneNASession2.itsCLValue = oneCLValueSession2;
    //setup 3rd NameArg - Option(U64) cltype
    NamedArg * oneNASession3 = [[NamedArg alloc] init];
    oneNASession3.itsName = @"id";
    CLValue * oneCLValueSession3 = [[CLValue alloc] init];
    CLType * oneCLTypeSession3 = [[CLType alloc] init];
    oneCLTypeSession3.itsType = CLTYPE_OPTION;
    oneCLTypeSession3.innerType1 = [[CLType alloc] init];
    oneCLTypeSession3.innerType1.itsType = CLTYPE_U64;
    CLParsed * oneCLParseSession3 = [[CLParsed alloc] init];
    CLParsed * parsed3Inner = [[CLParsed alloc] init];
    parsed3Inner.itsCLType = [[CLType alloc] init];
    parsed3Inner.itsCLType.itsType = CLTYPE_U64;
    parsed3Inner.itsValueStr = @"0";
    oneCLParseSession3.itsCLType = [[CLType alloc] init];
    oneCLParseSession3.itsCLType.itsType = CLTYPE_OPTION;
    oneCLParseSession3.itsCLType = oneCLTypeSession3;
    oneCLParseSession3.innerParsed1 = parsed3Inner;
    oneCLValueSession3.cl_type = oneCLTypeSession3;
    oneCLValueSession3.parsed = oneCLParseSession3;
    oneNASession3.itsCLValue = oneCLValueSession3;
    //setup 4th NameArg - key cltype
    NamedArg * oneNASession4 = [[NamedArg alloc] init];
    oneNASession4.itsName = @"spender";
    CLValue * oneCLValueSession4 = [[CLValue alloc] init];
    CLType * oneCLTypeSession4 = [[CLType alloc] init];
    oneCLTypeSession4.itsType = CLTYPE_KEY;
    CLParsed * oneCLParseSession4 = [[CLParsed alloc] init];
    oneCLParseSession4.itsValueStr = @"hash-dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b";
    oneCLParseSession4.itsCLType = [[CLType alloc] init];
    oneCLParseSession4.itsCLType.itsType = CLTYPE_KEY;
    oneCLParseSession4.itsCLType = oneCLTypeSession4;
    oneCLValueSession4.cl_type = oneCLTypeSession4;
    oneCLValueSession4.parsed = oneCLParseSession4;
    oneCLValueSession4.bytes = @"01dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b";
    oneNASession4.itsCLValue = oneCLValueSession4;
    
    //setup 5th NameArg - key ByteArray
    NamedArg * oneNASession5 = [[NamedArg alloc] init];
    oneNASession5.itsName = @"testBytesArray";
    CLValue * oneCLValueSession5 = [[CLValue alloc] init];
    CLType * oneCLTypeSession5 = [[CLType alloc] init];
    oneCLTypeSession5.itsType = CLTYPE_BYTEARRAY;
    CLParsed * oneCLParseSession5 = [[CLParsed alloc] init];
    oneCLParseSession5.itsValueStr = @"006d0be2fb64bcc8d170443fbadc885378fdd1c71975e2ddd349281dd9cc59cc";
    oneCLParseSession5.itsCLType = oneCLTypeSession5;
    oneCLValueSession5.cl_type = oneCLTypeSession5;
    oneCLValueSession5.parsed = oneCLParseSession5;
    oneCLValueSession5.bytes = @"006d0be2fb64bcc8d170443fbadc885378fdd1c71975e2ddd349281dd9cc59cc";
    oneNASession5.itsCLValue = oneCLValueSession5;
    //Put all the NameArg to the RuntimeArgs
    RuntimeArgs * raSession = [[RuntimeArgs alloc] init];
    raSession.listArgs = [[NSMutableArray alloc] init];
    [raSession.listArgs addObject:oneNASession];
    [raSession.listArgs addObject:oneNASession2];
    [raSession.listArgs addObject:oneNASession3];
    [raSession.listArgs addObject:oneNASession4];
   // [raSession.listArgs addObject:oneNASession5];
    ediSession.args = raSession;
    [session.itsValue addObject:ediSession];
    deploy.session = session;
    // Setup approvals
    NSMutableArray * listApprovals = [[NSMutableArray alloc] init];
    NSString * bodyHash = [deploy getBodyHash];
    dh.body_hash = bodyHash;
    NSString * deployHash = [deploy getDeployHash];
    deploy.itsHash = deployHash;
    NSLog(@"Deploy hash is:%@",deployHash);
    NSString * signature =  @"";
    if(isEd25519) {
        NSString * privateKeyStr = [ed25519 readPrivateKeyFromPemFile:@"ReadSwiftPrivateKeyEd25519.pem"];
        NSLog(@"Privaet kiey is:%@",privateKeyStr);
        signature = [ed25519 signMessageWithValue: deployHash withPrivateKey:privateKeyStr];
        NSLog(@"Signature is: %@",signature); //should add 01 prefix
        signature = [[NSString alloc] initWithFormat:@"01%@",signature];
        NSLog(@"Signature is: %@",signature);
    } else { //Sign with Secp256k1
        NSLog(@"Sign with Secp256k1");
        Secp256k1Crypto * secp = [[Secp256k1Crypto alloc] init];
        NSString * privateKeyPemStr = [secp secpReadPrivateKeyFromPemFile:@"ReadSwiftPrivateKeySecp256k1.pem"];
        PutDeployUtils.secpPrivateKeyPemStr = privateKeyPemStr;
        NSLog(@"private key pem string to putDeployUtils:%@",PutDeployUtils.secpPrivateKeyPemStr);
        signature = [secp secpSignMessageWithValue:deployHash withPrivateKey:privateKeyPemStr];
        signature = [[NSString alloc] initWithFormat:@"02%@",signature];
        NSLog(@"Signature is: %@",signature);
    }
    Approval * oneA = [[Approval alloc] init];
    if(isEd25519) {
        oneA.signer = accountEd25519;
    } else {
        oneA.signer = accountSecp256k1;
    }
    oneA.signature = signature;
    [listApprovals addObject:oneA];
    deploy.approvals = listApprovals;
    PutDeployRPC * putDeployRPC = [[PutDeployRPC alloc] init];
    [putDeployRPC initializeWithRPCURL:URL_TEST_NET];
    //PutDeployParams * putDeployParams = [[PutDeployParams alloc] init];
    //putDeployParams.deploy = deploy;
    //putDeployRPC.params = putDeployParams;
    //NSString * putJson = [deploy toPutDeployParameterStr];
    NSString * callPutDeployID = @"putDeployCall1";
    [putDeployRPC putDeployForDeploy:deploy andCallID:callPutDeployID];
    //[putDeployRPC putDeployWithJsonString:putJson andCallID:callPutDeployID];
    NSTimer * tPutDeploy = [NSTimer scheduledTimerWithTimeInterval: 1.0
                          target: self
                          selector:@selector(onTickPutDeploy:)
                                                 userInfo: @{@"param1":putDeployRPC,@"param2":callPutDeployID} repeats:YES];
   
}
-(void)onTickPutDeploy:(NSTimer *)timer {
    PutDeployRPC * item = [[timer userInfo] objectForKey:@"param1"];
    NSString * callID = [[timer userInfo] objectForKey:@"param2"];
    NSLog(@"Counting timer for put deploy: %i and result:%@",counterPutDeploy,item.rpcCallGotResult[callID]);
    if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_NOT_SET]) {
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_ERROR_OBJECT]) {
        NSLog(@"Put Deploy with parse error");
        [timer invalidate];
        timer = nil;
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALUE_ERROR_NETWORK]) {
        NSLog(@"Put deploy with network error");
        [timer invalidate];
        timer = nil;
    } else if([item.rpcCallGotResult[callID] isEqualToString:RPC_VALID_RESULT]){
        PutDeployResult * putResult = item.valueDict[callID];
        NSLog(@"Put deploy result, deploy hash:%@",putResult.deployHash);
        [timer invalidate];
        timer = nil;
    }
    counterPutDeploy ++;
    if(counterPutDeploy == maxCounter) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getStateRootHash];
    [self getPeer];
    [self testPutDeploy];
}
@end
