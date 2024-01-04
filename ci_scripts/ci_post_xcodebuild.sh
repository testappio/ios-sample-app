if [ "$CI_WORKFLOW" = "TestApp.io Upload" ]; then
    echo "Uploading to TestApp.io"

    export INSTALL_DIR=$(pwd)
    if [ ! -f ${INSTALL_DIR}/ta-cli ]; then
        curl -Ls https://github.com/testappio/cli/releases/latest/download/install | bash
    else
        ${INSTALL_DIR}/ta-cli version | grep "You are using the latest version"
        if [ $? -ne 0 ]; then
            curl -Ls https://github.com/testappio/cli/releases/latest/download/install | bash
        fi
    fi

    ta-cli publish --api_token=$TESTAPPIO_API_TOKEN --app_id=$TESTAPPIO_APP_ID --release="ios" --ipa=$CI_AD_HOC_SIGNED_APP_PATH/sample-app.ipa --release_notes=$release_notes --notify=$notify --source="Xcode Cloud"

fi
