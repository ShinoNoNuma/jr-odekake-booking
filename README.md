# JR Odekake Booking
Automatic booking application for ICOCA &amp; HARUKA

### Installation

_[Manual]_

* Download this: [https://github.com/ShinoNoNuma/jr-odekake-booking/zipball/master](https://github.com/ShinoNoNuma/jr-odekake-booking/zipball/master)
* Unzip that download.
* Copy the resulting folder to `ProjectName/lib/web_apis`

_[GIT Submodule]_

In your app directory type:

```shell
git submodule add -b master git://github.com/ShinoNoNuma/jr-odekake-booking lib/web_apis/jr.rb
git submodule init
git submodule update
```

_[GIT Clone]_

In your `web_apis` directory type:

```shell
git clone -b master git://github.com/ShinoNoNuma/jr-odekake-booking.git jr.rb
```

Don't forget to include the class JR into the desired model

```ruby
include WebApis::Jr 
```