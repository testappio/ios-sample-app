## Connect Expo EAS with CircleCI

In order to automatically trigger the CircleCI pipeline, we need to connect our CircleCI project to our repository.

When creating a new CircleCI project, you will have the option to connect a specific repository to the CircleCI project. After the two are linked, we just need to create the secrets/environment variables for the CircleCI project.

For more information about creating a CircleCI project, see [this](https://circleci.com/docs/create-project/).

### TestApp.io / CircleCI Secrets/Environment variables

In order to know where to upload the EAS build, you need to provide the secrets/environment variables in the Circle CI project. See [this](https://circleci.com/docs/set-environment-variable/#set-an-environment-variable-in-a-project) guide for how to add environment variables.

**The following environment variables needs to be set:**

- [TESTAPPIO_API_TOKEN](https://portal.testapp.io/settings/api-credentials)
- [TESTAPPIO_APP_ID](https://portal.testapp.io/apps?to=app-integrations&tab=releases)

### The build

In this example we are using the Expo EAS build tool to locally build the app on a CircleCI macOS virtual machine.

EAS is using Fastlane under the hood and is automatically preparing the credentials and signing the build for you. For more information about the local EAS iOS build process, refer to the [expo docs](https://docs.expo.dev/build-reference/ios-builds/).

#### [Filters](https://support.circleci.com/hc/en-us/articles/115015953868-Filter-workflows-by-branch-)

In the example configuration, if you look at the workflows in the config, we have a filter to only start the pipeline when the staging branch is changing. If you need to listen for code changes in other branches, just change this value to match your own branch name
