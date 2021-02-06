# LuckyDiff

Testing

![Crystal CI](https://github.com/stephendolan/lucky_diff/workflows/Crystal%20CI/badge.svg)
![Heroku](https://heroku-badge.herokuapp.com/?app=lucky-diff)

This project compares released versions of [Lucky](https://luckyframework.org) apps. It's heavily inspired by [RailsDiff](http://railsdiff.org). Enjoy!

## Is a version you need missing?

All supported versions are placed in the [generated](/generated/) folder, so adding a new version is as simple as following these steps:

1. Scaffold a new app with the appropriate Lucky version and standard app name: `lucky init.custom my_app`
1. Move the generated app to the `/generated/` folder, named after the version

## Want to add something to the site?

1. Fork it ( https://github.com/stephendolan/lucky_diff/fork )
1. Create your feature branch (git checkout -b my-new-feature)
1. Run `script/setup`
1. Make your changes
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request
