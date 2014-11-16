## [v0.9.0](https://github.com/yuki24/did_you_mean/tree/v0.9.0)

_<sup>released on 2014-11-09 01:26:31 UTC</sup>_

#### New Features

- did\_you\_mean now suggests instance variable names if `@` is missing ( [#12](https://github.com/yuki24/did_you_mean/issues/12 "Suggest instance- and class-vars"), [<tt>39d1e2b</tt>](https://github.com/yuki24/did_you_mean/commit/39d1e2bd66d6ff8acbc4dd5da922fc7e5fcefb20))

```ruby
@full_name = "Yuki Nishijima"
first_name, last_name = full_name.split(" ")
# => NameError: undefined local variable or method `full_name' for main:Object
#
#     Did you mean? @full_name
#
```

#### Bug Fixes

- Fixed a bug where did\_you\_mean changes some behaviours of Ruby 2.1.3/2.1.4 installed on Max OS X ( [#14](https://github.com/yuki24/did_you_mean/issues/14 "Compatibility with `letter\_opener` gem"), [<tt>44c451f</tt>](https://github.com/yuki24/did_you_mean/commit/44c451f8c38b11763ba28ddf1ceb9696707ccea0), [<tt>9ebde21</tt>](https://github.com/yuki24/did_you_mean/commit/9ebde211e92eac8494e704f627c62fea7fdbee16))
- Fixed a bug where sometimes `NoMethodError` suggests duplicate method names ( [<tt>9865cc5</tt>](https://github.com/yuki24/did_you_mean/commit/9865cc5a9ce926dd9ad4c20d575b710e5f257a4b))

## [v0.8.0](https://github.com/yuki24/did_you_mean/tree/v0.8.0)

_<sup>released on 2014-10-27 02:03:13 UTC</sup>_

**This version has been yanked from rubygems.org as it has a serious bug with Ruby 2.1.3 and 2.1.4 installed on Max OS X. Please upgrade to 0.9.0 as soon as possible.**

#### New Features

- JRuby support!

#### Bug Fixes

- Fixed a bug where did\_you\_mean unexpectedly disables [better\_errors](https://github.com/charliesome/better_errors)'s REPL
- Replaced [binding\_of\_caller](https://github.com/banister/binding_of_caller) dependency with [interception](https://github.com/ConradIrwin/interception)
- Fixed the wrong implementation of Levenshtein algorithm ( [#2](https://github.com/yuki24/did_you_mean/pull/2 "Fix bug of DidYouMean::Levenshtein#min3."), [@fortissimo1997](https://github.com/fortissimo1997))

## [v0.7.0](https://github.com/yuki24/did_you_mean/tree/v0.7.0)

_<sup>released on 2014-09-26 03:37:18 UTC</sup>_

**This version has been yanked from rubygems.org as it has a serious bug with Ruby 2.1.3 and 2.1.4 installed on Max OS X. Please upgrade to 0.9.0 as soon as possible.**

#### New Features

- Added support for Ruby 2.1.3, 2.2.0-preview1 and ruby-head
- Added support for ActiveRecord 4.2.0.beta1
- Word searching is now about 40% faster than v0.6.0
- Removed `text` gem dependency
- Better output on pry and Rspec

#### Small/Internal Changes

- A lot of internal refactoring

## [v0.6.0](https://github.com/yuki24/did_you_mean/tree/v0.6.0)

_<sup>released on 2014-05-18 00:23:24 UTC</sup>_

**This version has been yanked from rubygems.org as it has a serious bug with Ruby 2.1.3 and 2.1.4 installed on Max OS X. Please upgrade to 0.9.0 as soon as possible.**

#### New Features

- Added basic support for constants. Now you'll see class name suggestions when you misspelled a class names/module names:

```ruby
> Ocject
# => NameError: uninitialized constant Ocject
#
#     Did you mean? Object
#
```

#### Bug Fixes

- Fixed a bug where did\_you\_mean segfaults on Ruby head(2.2.0dev)

## [v0.5.0](https://github.com/yuki24/did_you_mean/tree/v0.5.0)

_<sup>released on 2014-05-10 17:59:54 UTC</sup>_

#### New Features

- Added support for Ruby 2.1.2

## [v0.4.0](https://github.com/yuki24/did_you_mean/tree/v0.4.0)

_<sup>released on 2014-04-20 02:10:31 UTC</sup>_

#### New Features

- did\_you\_mean now suggests a similar attribute name when you misspelled it.

```ruby
User.new(flrst_name: "wrong flrst name")
# => ActiveRecord::UnknownAttributeError: unknown attribute: flrst_name
#
#     Did you mean? first_name: string
#
```

#### Bug Fixes

- Fixed a bug where did\_you\_mean doesn't work with `ActiveRecord::UnknownAttributeError`

## [v0.3.1](https://github.com/yuki24/did_you_mean/tree/v0.3.1)

_<sup>released on 2014-03-20 23:16:20 UTC</sup>_

#### Small/Internal Changes

- Changed output for readability.
- Better algorithm to find the correct method.

## [v0.3.0](https://github.com/yuki24/did_you_mean/tree/v0.3.0)

_<sup>released on 2014-03-20 23:13:13 UTC</sup>_

#### New Features

- Added support for Ruby 2.1.1 and 2.2.0(head).

## [v0.2.0](https://github.com/yuki24/did_you_mean/tree/v0.2.0)

_<sup>released on 2014-03-20 23:12:13 UTC</sup>_

#### Incompatible Changes

- dropped support for JRuby and Rubbinious.

#### New Features

- did\_you\_mean no longer makes Ruby slow.

## [v0.1.0: First Release](https://github.com/yuki24/did_you_mean/tree/v0.1.0)

_<sup>released on 2014-03-20 23:11:14 UTC</sup>_

- Now you will have "did you mean?" experience in Ruby!
- but still very experimental since this gem makes Ruby a lot slower.