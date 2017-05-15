<img src="LicensePlist.png" width="200" height="200" alt="LicensePlist Logo"> LicensePlist
======================================

![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/mono0926/NativePopup/master/LICENSE)
[![Language: Swift](https://img.shields.io/badge/swift-3.1-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

`LicensePlist` is a command-line tool that automatically generates a Plist of all your dependencies, including files added manually(specified by [YAML config file](https://github.com/mono0926/LicensePlist/blob/master/Tests/LicensePlistTests/Resources/license_plist.yml)) or using `Carthage` or `CocoaPods`. All these licenses then show up in the Settings app.

App Setting Root | License List | License Detail
--- | --- | ---
![](Screenshots/root.png) | ![](Screenshots/list.png) | ![](Screenshots/detail.png)

## Installation

### Homebrew (Recommended)

```sh
$ brew install mono0926/license-plist/license-plist
```

Or 

```sh
$ brew tap mono0926/license-plist
$ brew install license-plist
```

### Download the executable binary from [Releases](https://github.com/mono0926/LicensePlist/releases)

Download from [Releases](https://github.com/mono0926/LicensePlist/releases), then copy to `/usr/local/bin/license-plist` etc.

Or you can also download the latest binary and install it by one-liner.

```sh
curl -fsSL https://raw.githubusercontent.com/mono0926/LicensePlist/master/install.sh | sh
```

### From Source

Clone the master branch of the repository, then run `make install`.

```sh
$ git clone https://github.com/mono0926/LicensePlist.git
$ make install
```

## Usage

1. On the directory same as `Cartfile` or `Pods`, simply execute `license-plist`.
2. `com.mono0926.LicensePlist.Output` directory will be generated.
3. Move the files in the output directory into your app's `Settings.bundle`.
    - [Settings.bundle's sample is here](Settings.bundle.zip)
    - The point is to [specify `com.mono0926.LicensePlist` as license list file on your `Root.plist`](https://github.com/mono0926/LicensePlist/blob/master/Settings.bundle/Root.plist#L19).

```
Settings.bundle
├── Root.plist
├── com.mono0926.LicensePlist
│   ├── APIKit.plist
│   ├── Alamofire.plist
│   └── EditDistance.plist
├── com.mono0926.LicensePlist.plist
├── en.lproj
│   └── Root.strings
└── ja.lproj
    └── Root.strings
```

### Options

You can see options by `license-plist --help`.

#### `--cartfile-path`

- Default: `Cartfile`

#### `--pods-path`

- Default: `Pods`

#### `--output-path`

- Default: `com.mono0926.LicensePlist.Output`
- Recommended: `--output-path YOUR_PRODUCT_DIR/Settings.bundle`


#### `--github-token`

- Default: None.
- `LicensePlist` uses GitHub API, so sometimes API limit error occures. You can avoid it by using github-token .
- [You can generate token here](https://github.com/settings/tokens/new)
    - `repo` scope is needed.

#### `--config-path`

- Default: `license_plist.yml`
- You can specify GitHub libraries(introduced by hand) and excluded libraries
    - [Example is here](https://github.com/mono0926/LicensePlist/blob/master/Tests/LicensePlistTests/Resources/license_plist.yml)


#### `--force`

- Default: false
- `LicensePlist` saves latest result summary, so if there are no changes, the program iterrupts.
    - In this case, **excecution time is less than 100ms for the most case**, so **you can run `LicensePlist` at `Build - Pre-actions` every time** 🎉
- You can run all the way anyway, by using `--force` flag.

#### `--add-version-numbers`

- Default: false
- When the library name is `SomeLibrary`, by adding `--add-version-numbers` flag, the name will be changed to `SomeLibrary (X.Y.Z)`.
    - `X.Y.Z` is parsed from CocoaPods and Cartfile information, and GitHub libraries specified at [Config YAML](https://github.com/mono0926/LicensePlist/blob/master/Tests/LicensePlistTests/Resources/license_plist.yml) also support this flag.

<img src="https://cloud.githubusercontent.com/assets/1255062/25931869/f15d2df2-3649-11e7-8c7d-bb37d11adca0.png" width="320" height="568" alt="License list with versions">

### Integrate into build

Add `Run Script` to `Build - Pre-actions`:

```sh
if [ $CONFIGURATION = "Debug" ]; then
cd $SRCROOT
/usr/local/bin/license-plist --output-path $PRODUCT_NAME/Settings.bundle
fi
```

![](Screenshots/pre_build_action.png)


## Q&A

### How to generate Xcode project?

Execute `swift package generate-xcodeproj` or `make xcode`.
