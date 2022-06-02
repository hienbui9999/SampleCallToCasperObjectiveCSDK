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

Note: For account_put_deploy task, you need to configuration the path for the Pem file of Ed25519 and Secp256k1 crypto. 
First you have to choose 1 folder in your Mac device to read/write the Public/Private key for both Ed25519 and Secp256k1 when build/run the Package from Xcode. You if do not do this step. The test will sure fail.

This step is just an example for the setting up the Pem file path and place, you can put create your own folder, put the Pem file and then point the path to the Pem file in that folder. As long as these things is set up correctly, the SDK will build and run without error. If you are not sure of what to do, just follow these steps below.

Under folder "Users" in your Mac create 1 folder with name "CasperObjectiveCCryptoTest", then under that newly created folder create two more folder "Ed25519" and "Secp256k1"

After this step finish, you will have 2 folder which are:

"Users/CasperObjectiveCCryptoTest/Ed25519" and "Users/CasperObjectiveCCryptoTest/Secp256k1"

Under the "Crypto" folder of this Project you will see 2 folders "Ed25519" and "Secp256k1". In folder "Ed25519" you will see 2 files: "ReadSwiftPrivateKeyEd25519.pem" and "ReadSwiftPublicKeyEd25519.pem", In folder "Secp256k1" you will see 2 files: "ReadSwiftPrivateKeySecp256k1.pem" and "ReadSwiftPublicKeySecp256k1.pem". They are the pre-build pem key files, used for task of reading Pem file to Private/Public key.

Copy 2 files: "ReadSwiftPrivateKeyEd25519.pem" and "ReadSwiftPublicKeyEd25519.pem" to folder "Users/CasperObjectiveCCryptoTest/Ed25519"

Copy 2 files: "ReadSwiftPrivateKeySecp256k1.pem" and "ReadSwiftPublicKeySecp256k1.pem" to folder "Users/CasperObjectiveCCryptoTest/Secp256k1", somehow the structure of the folder is like this


<img width="1232" alt="Screen Shot 2022-06-01 at 10 24 23" src="https://user-images.githubusercontent.com/94465107/171321860-3bb780ee-334e-43d8-b533-3ad31ad22a42.png">

<img width="1240" alt="Screen Shot 2022-06-01 at 10 25 09" src="https://user-images.githubusercontent.com/94465107/171321878-13482457-1dfe-47c1-9276-d898a0205a7e.png">
