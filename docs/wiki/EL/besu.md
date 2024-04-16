### Besu Execution Client
This is a brief summary of important information you need to know when starting to contribute to BESU:
#### Code directoy explanation

##### Modules
+  It is a multi-module [gradle](https://gradle.org/) project. You can take a look to settings.gradle to see all modules :
    + Each module has its own build.gradle:
		+ You can specify it's module name: `archiveBaseName`
		+ You can specify it's dependencies but without versions.
	+ Each module has its own source code here: /src/main/java
+ **There are top-level modules**:
	+ Config:
		+ Where most of the configuration is assembled, validated.
		+ You can find the genesis information.
	+ Besu:
		+ All the CL arguments are being defined.
		+ Is where the main method is located.
+ **There are complementary modules**:
	+ crypto:
		+ Everything relative to cryptographics keys.
		datatypes:
		+ Det of types being used by Besu.
	+ metrics:
		+ Teemetry/prometheus not tight to internal besu.
	+ ethereum:
		+ Is not a module but contains modules :
			+ api :
				+ All interaction you want to have with ethereum, world state.
			+ core: 
				+ Stroring date, quourm setup.
	+ evm:
		+ EVM behaviour
		+ In this module you can find each opcode operation implementation.
+ **There are enterprise modules:** 
	+ enclave, plugin-api, privacy-contracts

##### Gradle
+ gradlew (file) :
	+ It is a bash script that will check if gradle is installed or not ( will install the wrapper for you and download the whole distribution)
	+ Gradle itself is managed as part of a wrapper that is used by calling this script.
+ gradle (folder):
	+ gradle-wrapper.properties:
		+ distributionURL : points to the distribution to be used when calling ./gradlew
	+ versions.gradle (file):
		+ It is where all module's versions are defined. It is used by gradlew.
+ build.gradle (file):
	+ plugins:
		+ spotless: Code formatting, check licensing, etc,
			+ Command:  `./gradlew spotlessApply`
		+ errorprone:  Compliance with best practises in Java.
			+ Command:  `./gradlew errorProne`
	+ distribution:
		+ It defines where the building output is left by taking all projects into an application:
			+ .tar .zip distributions. You can see a .tar or .zip under builder/distributions.
+ build (folder):
	+ It's not a module.
	+ distributions (folder):
		+ Location of the Besu distribution.
		+ If you go deeper to build/distribution/besu-{version}-SNAPSHOT/lib you can see each version of each component and libraries.

##### Testing
+ Unit tests:
	+ Each module has its unit testing under src/test/java
+ Integration tests:
	+ Each module has its integration test under src/integration-test/java:
	+ Are more rare.
	+ Are run outside of the inner internals of the code.
	+ Are involved in more expensive runs.
+ Acceptance tests:
	+ Are located under the acceptance-test-module.
	+ Runs multple Besu's nodes to create consensus algorithm between them and performing task adjusting and propagating blocks.
+ Reference tests:
	+ Taken after Ethereum tests, borrowed by the Ethereum foundation.
	+ Are the same for all clients: https://github.com/ethereum/tests
	+ Are stored in JSON:
		+ Location: ethereum/referencetests/
+ Other info:
	+ JUnit 4


#####  Development tasks:
+ Some useful commands:
	+ `git pull --recurse-submodules`.
	+ `./gradlw spotlessApply`
	+ `./gradlw check` (it is run by CI every time you make a PR to Besu repository)
	+  `./gradlew assemble`
	+  In case you want to connect your MM to your local Besu node, you should run Besu with these options:
		+ bin/besu --network=dev --rpc-http-enabled --rpc-http-cors-origins=chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn
		+ RPC URL: http://localhost:8545


#####  Important classes:
+ BesuControllerBuilder:
	+ Manages all the components tha are going to be used and needed to setup the client.
	+ On the build method you can see if you are building the correct domain object.
	+ It returns a BesuController.
+ BesuCommand:
	+ Represents the main Besu CLI command.
+ ForkIdManager:
	+ Responsable for building and representing the latest fork syncronized.
	+ We always need to know where we are in terms of our own chain. This check is done constantly.
	+ It is created on EthProtocolManager which is created on BesuControllerBuilder. 
+ ProtocolShedule:
	+ Keeps track of all the configuration items as part of a specific range of block numbers for a chain.
+ ProtocolSpec:
	+ Let's you configure every aspect of how things work inside the protocol.
+ MainnetProtocolSpec:
	+ You will find every spec since frontier.
	+ Each new spec is built on top of the previous one and add or change what is necessary.
+ MainnetEVms:
	+ Provides EVms supporting the appropriate operations for mainnet hard forks.
	+ It is an aggregate state where most of the time you will adding new features to the spec itself.
	+ New operations will be registered here.
+ JsonRpcMethodsFactory:
	+ A builder class for RPC methods.
	+ From here you can understand how to create new RPC methods.


##### Important libraries:
+ https://doc.libsodium.org/:
	+ Sodium is a modern, easy-to-use software library for encryption, decryption, signatures, password hashing, and more.
+ https://github.com/nss-dev/nss:
	+ Network Security Services (NSS) is a set of libraries designed to support cross-platform development of security-enabled client and server applications. NSS supports TLS 1.2, TLS 1.3, PKCS #5, PKCS#7, PKCS #11, PKCS #12, S/MIME, X.509 v3 certificates, and other security standards.

####### References:
+ https://www.youtube.com/watch?v=4pCxwuNRaKg
+ https://github.com/hyperledger/besu
+ https://wiki.hyperledger.org/display/besu