![maze](https://github.com/mazeframework/mazeframework.github.io/blob/master/assets/images/maze.svg)

**Productivity. Performance. Happiness.**

_Maze makes building web applications fast, simple, and enjoyable - with fewer bugs and blazing fast performance._

[![Build Status](https://travis-ci.org/mazeframework/maze.svg?branch=master)](https://travis-ci.org/mazeframework/maze)
[![Version](https://img.shields.io/github/tag/mazeframework/maze.svg?maxAge=360)](https://github.com/mazeframework/maze/releases/latest)
[![Dependencies](https://shards.rocks/badge/github/mazeframework/maze/status.svg)](https://shards.rocks/github/mazeframework/maze)
[![License](https://img.shields.io/github/license/mazeframework/maze.svg)](https://github.com/mazeframework/maze/blob/master/LICENSE)
[![Gitter](https://img.shields.io/gitter/room/mazeframework/maze.svg)](https://gitter.im/mazeframework/maze)

# Welcome to Maze

**Maze** is a web application framework written in [Crystal](http://www.crystal-lang.org) inspired by Kemal, Rails, Phoenix and other popular application frameworks and based on [Amber](https://amberframework.org).  The purpose of Maze is to extend Amber with specific features and design goals that are outside of, and incompatible with, the core goals of the Amber project.

Maze has a number of fundamental differences from Amber which meant creating a new framework was a better option than trying to modify Amber whilst retain Amber's core principles. With Amber anyone coming from a Rails background will feel right at home as the Amber application layout has many similarities with Rails.  In particular Model, Views and Controllers are contained in app/models, app/views and app/controllers directories respectively.

Maze takes a modular approach whereby the code is organised in modules for a feature or module of your application.  Anyone who has used MEAN.js will be familiar with this code layout scheme.  For example given an application feature to perform CRUD operations on Post objects (e.g. title, bodytext etc.)  The code layout in Maze for the Post module would be as such (using the slang template engine);

```
src/modules
src/modules/post
src/modules/post/_form.slang
src/modules/post/edit.slang
src/modules/post/post_controller.cr
src/modules/post/show.slang
src/modules/post/post.cr    # the Post model
src/modules/post/index.slang
src/modules/post/new.slang
```

This does not preclude models, views and controllers in the src/models, src/views and src/controllers directories.  That layout scheme is still available and a Maze app can contain code in both layouts simultaneously.  The difference between the two layout schemes is in the render() method.  For the standard Rails/Amber paradigm render a template (and partial) with the **render** method.  For the modular paradigm render a template (and partial) with the **render_module** method.

Maze borrows concepts that have already been battle tested and successful, and embraces new concepts through team and community collaboration and analysis, which also aligns with Crystal's philosophy.

## Community

Questions? Join our IRC channel [#maze](http://webchat.freenode.net/?channels=#maze) and [Gitter room](https://gitter.im/mazeframework/maze) or ask on Stack Overflow under the [maze-framework](https://stackoverflow.com/questions/tagged/maze-framework) tag.

Guidelines? We have adopted the Contributor Covenant to be our [CODE OF CONDUCT](.github/CODE_OF_CONDUCT.md) for Maze.

Our Philosophy? [Read Maze Philosophy H.R.T.](.github/MAZE_PHILOSOPHY.md)

## Documentation

Read Maze documentation on https://mazeframework.gitbook.io/maze/

## Amber Benchmarks

[Techempower Framework Benchmarks - Round 15 (2018-02-14)](https://www.techempower.com/benchmarks/#section=data-r15&hw=ph&test=fortune&f=zik073-zik0zj-zik0zj-zik0zj-zhxjwf-zik0zj-gnbmym-cn3)

Fortunes test comparing [Amber](https://amberframework.org/), [Kemal](https://kemalcr.com/), [Rails](https://rubyonrails.org/), [Phoenix](https://phoenixframework.org/), and [Hanami](https://hanamirb.org/):

[![framework-benchmark](https://github.com/amberframework/site-assets/raw/master/images/benchmarks-fortunes.png "TFB Fortunes test for Crystal, Elixir and Ruby frameworks")](https://www.techempower.com/benchmarks/#section=data-r15&hw=ph&test=fortune&f=zik073-zik0zj-zik0zj-zik0zj-zhxjwf-zik0zj-gnbmym-cn3)

## Installation & Usage


#### MacOS or Linux

```
git clone https://github.com/mazeframework/maze.git
cd maze
git checkout stable
make
sudo make install
```

#### Common

To compile a local `bin/maze` per project use `shards build maze`

To use it as dependency, add this to your application's `shard.yml`:

```yaml
dependencies:
  maze:
    github: mazeframework/maze
```

[Read more about Maze CLI installation guide](https://mazeframework.org/guides/getting-started/Installation/README.md#installation)

[Read Maze guide from zero to deploy](https://mazeframework.org/guides/getting-started/quickstart/zero-to-deploy.md#zero-to-deploy)

[Read Maze CLI commands usage](https://mazeframework.org/guides/getting-started/cli/README.md#cli-readme)

## Have a Maze-based Project?

Use Maze badge

![Maze Framework](https://img.shields.io/badge/using-maze%20framework-orange.svg)

```markdown
[![Maze Framework](https://img.shields.io/badge/using-maze%20framework-orange.svg)](Your project url)
```

## Contributing

Contributing to Maze can be a rewarding way to learn, teach, and build experience in just about any skill you can imagine. You don’t have to become a lifelong contributor to enjoy participating in Maze.

Tracking issues? Check our [project board](https://github.com/orgs/mazeframework/projects/1?fullscreen=true).

Code Triage? Join us on [codetriage](https://www.codetriage.com/mazeframework/maze).

[![Open Source Contributors](https://www.codetriage.com/mazeframework/maze/badges/users.svg)](https://www.codetriage.com/mazeframework/maze)

Maze is a community effort and we want You to be part of it. [Join Maze Community!](https://github.com/mazeframework/maze/blob/master/.github/CONTRIBUTING.md)

1. Fork it https://github.com/mazeframework/maze/fork
2. Clone your fork to your local workstation
3. Create your feature branch `git checkout -b my-new-feature`
4. Write and execute specs `crystal spec`
5. Commit your changes `git commit -am 'Add some feature'`
6. Push to the branch `git push origin my-new-feature`
7. Create a new Pull Request

## Contributors

- [Damian Hamill](https://github.com/damianham "damianham")

[See more Maze contributors](https://github.com/mazeframework/maze/graphs/contributors)

## Amber Contributors

- [Dru Jensen](https://github.com/drujensen "drujensen")
- [Elias Perez](https://github.com/eliasjpr "eliasjpr")
- [Isaac Sloan](https://github.com/elorest "elorest")
- [Faustino Aguilar](https://github.com/faustinoaq "faustinoaq")
- [Nick Franken](https://github.com/fridgerator "fridgerator")
- [Mark Siemers](https://github.com/marksiemers "marksiemers")
- [Robert Carpenter](https://github.com/robacarp "robacarp")

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Based on [Amber](https://amberframework.org)
* Inspired by [Kemal](https://kemalcr.com/), [Rails](https://rubyonrails.org/), [Phoenix](https://phoenixframework.org/), and [Hanami](https://hanamirb.org/),
