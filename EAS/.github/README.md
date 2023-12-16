## Building iOS with GitHub Actions

We recommend using CircleCI over GitHub Actions when building your iOS apps, since the macOS runners that GitHub hosts consume 10 times the rate that jobs on Linux runners consume. See article [here](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions#minute-multipliers).

Example: 1 minute of running and building your app on the macOS runner is actually counting for 10 minutes, which will probably eat up your free 2000 minutes pretty fast.
