# LuckyDiff

[![Lucky](https://github.com/stephendolan/lucky_diff/actions/workflows/lucky.yml/badge.svg)](https://github.com/stephendolan/lucky_diff/actions/workflows/lucky.yml)
[![Tuple](https://img.shields.io/badge/Pairing%20with-Tuple-5A67D8)](https://tuple.app)

This project compares released versions of [Lucky](https://luckyframework.org) apps. It's heavily inspired by [RailsDiff](http://railsdiff.org). Enjoy!

## Is a version you need missing?

All supported versions are placed in the [generated](/generated/) folder, so adding a new version is as simple as following these steps:

1. Fork it ( https://github.com/stephendolan/lucky_diff/fork )
1. Check out a new branch (git checkout -b add-version-x-x-x)
1. Run `./script/create_new_version vx.x.x`
1. Add your new version to `src/models/version.cr`
1. Run the server with `lucky dev` and verify the content
1. Commit your changes (git commit -am 'Add version x.x.x')
1. Push to the branch (git push origin add-version-x-x-x)
1. Create a new Pull Request

## Want to add something to the site?

1. Fork it ( https://github.com/stephendolan/lucky_diff/fork )
1. Create your feature branch (git checkout -b my-new-feature)
1. Run `script/setup`
1. Make your changes
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request
