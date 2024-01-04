if [ "$CI_WORKFLOW" = "TestApp.io Upload" ]; then
    echo "Uploading to TestApp.io"
    curl -Ls https://github.com/testappio/cli/releases/latest/download/install | bash

    chmod +x ta-cli

    ta-cli publish --api_token=$TESTAPPIO_API_TOKEN --app_id=$TESTAPPIO_APP_ID --release="ios" --ipa=$CI_AD_HOC_SIGNED_APP_PATH/sample-app.ipa --release_notes=$release_notes --notify=$notify --source="Xcode Cloud"

fi
