# SampleCallToCasperObjectiveCSDK

This is  a sample project used to demonstrate how to use Casper ObjectiveC SDK from other Objective C Project.

The Casper ObjectiveC SDK is at this address:

https://github.com/tqhuy2018/Casper-ObjectiveC-sdk

This project is just a very simple IOS App with StoryBoard interface, but the interface is just do nothing. Only the code behind the scene does the work of calling the Casper ObjectiveC SDK.

The main call is done in file 

https://github.com/hienbui9999/SampleCallToCasperObjectiveCSDK/blob/main/ObjectiveCApp1/ViewController.m

There are 3 sample RPC calls in this sample project:

1) chain_get_state_root_hash 
2) info_get_peers
3) account_put_deploy

You can easily implement other methods just by importing the corresponding library of the ObjectiveC SDK and make the call some how like the three above methods.

**Note: For account_put_deploy task, you need to configuration the path for the Pem file of Ed25519 and Secp256k1 crypto.**

First you have to choose 1 folder in your Mac device to read/write the Public/Private key for both Ed25519 and Secp256k1 when build/run the Package from Xcode. You if do not do this step. The test will sure fail.

This step is just an example for the setting up the Pem file path and place, you can put create your own folder, put the Pem file and then point the path to the Pem file in that folder. As long as these things is set up correctly, the SDK will build and run without error. If you are not sure of what to do, just follow these steps below.

Under folder "Users" in your Mac create 1 folder with name "CasperObjectiveCCryptoTest", then under that newly created folder create two more folder "Ed25519" and "Secp256k1"

After this step finish, you will have 2 folder which are:

"Users/CasperObjectiveCCryptoTest/Ed25519" and "Users/CasperObjectiveCCryptoTest/Secp256k1"

There are 2 folder ins this Project with name "Ed25519" and "Secp256k1". In folder "Ed25519" you will see 2 files: "ReadSwiftPrivateKeyEd25519.pem" and "ReadSwiftPublicKeyEd25519.pem", In folder "Secp256k1" you will see 2 files: "ReadSwiftPrivateKeySecp256k1.pem" and "ReadSwiftPublicKeySecp256k1.pem". They are the pre-build pem key files, used for task of reading Pem file to Private/Public key.

Copy 2 files: "ReadSwiftPrivateKeyEd25519.pem" and "ReadSwiftPublicKeyEd25519.pem" to folder "Users/CasperObjectiveCCryptoTest/Ed25519"

Copy 2 files: "ReadSwiftPrivateKeySecp256k1.pem" and "ReadSwiftPublicKeySecp256k1.pem" to folder "Users/CasperObjectiveCCryptoTest/Secp256k1", somehow the structure of the folder is like this


<img width="1232" alt="Screen Shot 2022-06-01 at 10 24 23" src="https://user-images.githubusercontent.com/94465107/171321860-3bb780ee-334e-43d8-b533-3ad31ad22a42.png">

<img width="1240" alt="Screen Shot 2022-06-01 at 10 25 09" src="https://user-images.githubusercontent.com/94465107/171321878-13482457-1dfe-47c1-9276-d898a0205a7e.png">

The path for the key Ed25519 can change in this line of the file "ViewController.m" file

 ```ObjectiveC
NSString * fileName = @"ReadSwiftPrivateKeyEd25519.pem";
NSString * privateKeyPath = [[NSString alloc] initWithFormat:@"%@%@",CRYPTO_PATH_ED25519,fileName];
```

 and for Secp256k1 the code is:
 
  ```ObjectiveC
 NSString * fileName = @"ReadSwiftPrivateKeySecp256k1.pem";
 NSString * privateKeyPath = [[NSString alloc] initWithFormat:@"%@%@",CRYPTO_PATH_SECP256K1,fileName];
 ```
 
If you put the Pem file of Ed25519 in your Mac folder with full path such as "/Users/YourName/Crypto/Ed25519.pem" then just simple replace the code from:

 ```ObjectiveC
NSString * fileName = @"ReadSwiftPrivateKeyEd25519.pem";
NSString * privateKeyPath = [[NSString alloc] initWithFormat:@"%@%@",CRYPTO_PATH_ED25519,fileName];
```
to 

 ```ObjectiveC
NSString * privateKeyPath = @"/Users/YourName/Crypto/Ed25519.pem";
```

Or if you put Pem file of Secp256k1 in your Mac folder with full path such as "/Users/YourName/Crypto/Secp256k1.pem" then just simple replace the code from:

 ```ObjectiveC
 NSString * fileName = @"ReadSwiftPrivateKeySecp256k1.pem";
 NSString * privateKeyPath = [[NSString alloc] initWithFormat:@"%@%@",CRYPTO_PATH_SECP256K1,fileName];
```
to 

 ```ObjectiveC
NSString * privateKeyPath = @"/Users/YourName/Crypto/Secp256k1.pem";
```
Make sure that you point to the correct pem file path and Xcode has the right to read the file. 

After making these steps, you can Run the project and see the result in the Log panel of Xcode. Press Cmd + Shift + Y to view the Log panel.

After Runing the Project (By hitting Product->Run) you will see the result in the log like this:

<img width="1440" alt="Screen Shot 2022-06-02 at 21 12 05" src="https://user-images.githubusercontent.com/94465107/171652627-3481e6fe-075f-4044-9bce-cfdad2e5ad0a.png">

