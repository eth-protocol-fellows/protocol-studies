### Besu Execution Client
This is a brief summary of important information you need to know when starting to contribute to BESU:
#### Code directoy explanation

##### Modules
+  It is a multi-module [gradle](https://gradle.org/) project. You can take a look to settings.gradle to see all modules :
    + Each module has its own build.gradle:
		+ You can specify its module name: `archiveBaseName`
		+ You can specify its dependencies but without versions.
	+ Each module has its own source code here: /src/main/java
+ **There are top-level modules**:
	+ Config:
		+ Where most of the configuration is assbled, validated.
		+ You can find the genesis information. 
	+ Besu:
		+ All the CL arguments are being defined.
		+ Is where the main method is located.
+ **There are complementary modules**:
	+ crypto:
		+ Everything relative to cryptographics keys.
		datatypes:
		+ set of types being used by Besu.
	+ metrics:
		+ telemetry/prometheus not tight to internal besu.
	+ ethereum 
		+ Is not a module but contains modules :
			+ api :
				+ All interaction you want to have with ethereum, world state.
			+ core: 
				+ Stroring date, quourm setup.
			+ eth:
+ **There are enterprise modules:** enclave, plugin-api, privacy-contracts

##### Gradle
+ gradlew (file) :
	+ It is a bash script that will check if gradle is installed or not ( will install the wrapper for you and download the whole distribution) 
	+ Gradle itself is managed as part of a wrapper that is used by calling this script.
+ gradle (folder):
	+ gradle-wrapper.properties:
		+ distributionURL : points to the distribution to be used when calling ./gradlew
	+ versions.gradle (file):
		+ It is where all module's versions are defined. It is used by gradlew
+ build.gradle (file):
	+ plugins:
		+ spotless: Code formatting, check licensing, etc,
			+ Command:  `./gradlw spotlessApply`
		+ errorprone:  Compliance with best practises in Java.
			+ Command:  `./gradlw errorProne`
	+ distribution:
		+ It defines where the building output is left by taking all projects into an application:
			+ .tar .zip distributions. You can see a .tar or .zip under builder/distributions.
			+ docker 
+ build (folder):
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
	+ `./gradlw spotlessApply`
	+ `./gradlw check` (it is run by CI every time you make a PR to Besu repository)
	+  `./gradlew assemble`.

#####  Important classes:
+ BesuControllerBuilder:
	+ Manages all the components tha are going to be used and needed to setup the client.
	+ On the build method you can see if you are building the correct domain object.
	+ It returns a BesuController.
+ BesuCommand:
	+ Represents the main Besu CLI command.
+ ForkIdManager: 

##### References:
+ https://www.youtube.com/watch?v=4pCxwuNRaKg
+ https://github.com/hyperledger/besu
+ https://wiki.hyperledger.org/display/besu
