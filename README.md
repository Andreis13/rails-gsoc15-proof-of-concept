# GSoC'15 Proof of Concept

### Autoreloading based on events VS standard Rails autoreloading

This application is meant to demonstrate the performance (lack of it) of Rails
standard automatic file reloading when working with multiple files.
It as well presents a raw implementation of an event-based
autoreloading system and compares both approaches.

For this purpose I generated a bunch of folders and files in `lib/rails_autoload`.
Their contents look like this:

``` ruby
module Foo_1
  class Bar
    def self.inspect
      "I'm Foo 1"
    end
  end
end
```

In the `.env` file there is a switch for toggling the autoreload mechanism that
will be used on the `lib/rails_autoload` folder when the server is started.

- `FS_EVENTS=false` - this one just adds an entry to `config.autoload_paths`
- `FS_EVENTS=true` - when the flag is set to "true", the `listen` gem will be initialized
and set to listen all the modification events that will come from the `lib/rails_autoload` folder
and its subfolders. This happens in `initializers/evented_reloader.rb`. There
is also a callback that is set for file-modification events. What it does
is just load the code from the file that triggered the event.


In order to test this whole thing I created a route `/foo` which renders the text
returned by `Foo_1::Bar.inspect`. Therefore, after starting a server it is possible
to see the live file autoreloading by modifying the code in `/lib/rails_autoload/foo_1/bar.rb`
and refreshing the page. It works for both autoreloading mechanisms.

--------------------------------------

Now that we have the possibility to switch between the standard autoreloading technique
and the one based on file-system events, let's see which one performs better.
For this purpose I created a rake task (`rake profile:rails_autoreload`) that performs 100 requests on `/foo`,
first without modifying any files inbetween the requests, and then 100 more
but this time calling `FileUtils#touch` on a file before each request in order to make
Rails to reload this file.

This procedures are benchmarked and here are the results I have got for different settings in the `.env` file:

- For `FS_EVENTS=false`

```
                                     user     system      total        real
no file modifications:           0.070000   0.020000   0.090000 (  4.042461)
autoreloading modified files:    0.070000   0.020000   0.090000 (  5.292976)
```

- For `FS_EVENTS=true`
```
                                     user     system      total        real
no file modifications:           0.070000   0.020000   0.090000 (  0.684484)
autoreloading modified files:    0.080000   0.030000   0.110000 (  0.866244)
```

As we can see, reloading files based on events gives us a performance boost during development.

