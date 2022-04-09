- [IOS](#ios)
  - [Configure the project](#configure-the-project)
  - [Configure GitHub repository](#configure-github-repository)
  - [Sample files](#sample-files)
## IOS
You can find the sample project [here](https://github.com/testappio/ios-sample-app)
### Configure the project
1. Install Fastlane

The below command works for most cases. If not, please check [Setup Fastlane](https://docs.fastlane.tools/getting-started/ios/setup/)

``` bash
bundle install fastlane
```

2. Init Fastlane

In the iOS project folder
``` bash
bundle exec fastlane init
```

And follow the wizard; it will create `./fastlane/Appfile` with your Apple ID and team. 

3. Init `Match`

[Fastlane **match**](https://docs.fastlane.tools/actions/match/) is a tool for generating all necessary certificates and provisioning profiles and storing them in a Git repository encrypted.

Create a private empty Github repository for storing certificates and provisioning profiles.

``` bash
bundle exec fastlane match init
```
Follow the instruction, give the new empty git repository when asked, and it will create the `Matchfile`. 

4. Generate the certificate and provision profile

``` bash
bundle exec fastlane match adhoc
```

Following the instruction, it will generate certificates/profiles and store them in the Git repository specified in the previous step. 

>Note: Provide a matching password that is used for encrypting the certificates and profiles in the Git repository.

5. Select provisioning profiles in Xcode

The newly created certificates and profiles should now be possible to select inside our project. Open up Xcode and go to Signing & Capabilities. 

>Note: Don't choose Automatically manage signing

### Configure GitHub repository
1. Add following GibHub Action secrets
  
    Go to github repository `Settings` Page, go to **Secrets** and then **Actions**, click on `New repository secret` to configure a new secret. E.g.
![add-secret](images/add-secret.jpg)

Now, we can refer **MATCH_PASSWORD** in the github workflow as `${{ secret.MATCH_PASSWORD }}`
    Secret Name|Comments|
    ---|---|
    MATCH_PASSWORD| Used to decrypt the certificates and provisioning profiles
    FASTLANE_PASSWORD| The password for your Apple ID
    TESTAPPIO_API_TOKEN| The API Token for Testapp.io
    TESTAPPIO_APP_ID| The App Id for Testapp.io



2. Add `MATCH_GIT_BASIC_AUTHORIZATION` secrets
    * Create Github `Personal access token`   
        Go to Github Settings -> Developer Settings -> Personal access tokens, and click `Generate new token` button to generate a new Personal access token. Put note 'For fastlane match', and select `Repo` to ensure the token has access to all the private repositories. Save the token carefully, this is the **ONLY** time you can see the token.
    * Generate the basic authorization token
        ``` bash
        echo -n your_github_username:your_personal_access_token | base64
        ```
    * Add secret `MATCH_GIT_BASIC_AUTHORIZATION` and give it the value generated in previous step.
### Sample files
1. Sample Fastlane file

``` ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to Testapp.io"
  before_all do
    setup_ci
  end

  lane :development do
    match(type: "development")
    gym(export_method: "development")
    upload_to_testappio(
      release_notes: "For test only"
    )
  end
end
```

2. Sample Github workflow

``` yml
name: Workflow to upload IPA to TestApp.io

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  ios:
    name: Build and upload to Testappio
    runs-on: macos-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '2.7.2'
      - uses: maierj/fastlane-action@v2.2.0
        env:
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          FASTLANE_PASSWORD: ${{ secrets.FASTLANE_PASSWORD }}
          TESTAPPIO_API_TOKEN: ${{ secrets.TESTAPPIO_API_TOKEN }}
          TESTAPPIO_APP_ID: ${{ secrets.TESTAPPIO_APP_ID }}
          MATCH_GIT_BASIC_AUTHORIZATION: ${{ secrets.MATCH_GIT_BASIC_AUTHORIZATION }}
        with:
          lane: 'ios development'
          verbose: true
```

3. Finally push the changes to your repository and trigger the workflow. 