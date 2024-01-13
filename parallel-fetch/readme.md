# parallel fetch

This script reads a toml file containing tools available on GitHub and
calls the GitHub API to get the latest versions.

Using the `par-each` the API calls should all happen in parallel.
