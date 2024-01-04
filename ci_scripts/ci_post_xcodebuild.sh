if [ "$CI_PRODUCT_PLATFORM" = "iOS" ]; then
    echo "Uploading to TestApp.io"

    # Download and install TestApp.io CLI
    curl -Ls https://github.com/testappio/cli/releases/latest/download/install | bash

    # Make the CLI executable
    chmod +x ./ta-cli

    # Find the .ipa file in the specified directory
    IPA_FILE=$(find "$CI_AD_HOC_SIGNED_APP_PATH" -name "*.ipa" -print -quit)

    # Check if an .ipa file was found
    if [ -z "$IPA_FILE" ]; then
        echo "No .ipa file found in $CI_AD_HOC_SIGNED_APP_PATH"
        exit 1
    fi

    # Publish using the found .ipa file
    ./ta-cli publish --api_token=$TESTAPPIO_API_TOKEN --app_id=$TESTAPPIO_APP_ID --release="ios" --ipa="$IPA_FILE" --git_release_notes=true --git_commit_id=true --notify=true --source="Xcode Cloud"
fi
