# Contributing to LuckyDiff

### Contributing site fixes/functionality

1. Fork it ( https://github.com/stephendolan/lucky_diff/fork )
1. Create your feature branch (git checkout -b my-new-feature)
1. Install docker and docker-compose: https://docs.docker.com/compose/install/
1. Run `docker-compose up` to set up your database
1. Run `script/setup` to build the Docker containers with everything you need.
1. Make your changes
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request

### Adding versions

All supported versions are placed in the [generators](/generators/) folder, so adding a new version is as simple as following these steps:

1. Scaffold a new app with the appropriate Lucky version and standard app name: `lucky init.custom my_app`
1. Move the generated app to the `/generated/` folder, named after the version
