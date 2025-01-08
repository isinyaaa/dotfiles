# eseal Fish Theme

Minimal and informative fish prompt.

![eseal](https://user-images.githubusercontent.com/39812919/179360665-85b95ee2-cb82-46b8-9880-3f33c4dc49da.png)

## Features

- Last command
- LOTS of git status
- Shortened current directory
- `time` and `date` (so you always know how long you've been editing that damn
  file)

_Note:_ This theme is designed for a light-on-dark theme like
    [Solarized](http://ethanschoonover.com/solarized).

## Installation

Install using
    [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish):

```fish
omf install eseal
omf theme eseal
```

## Configuration

Set the list of default users by adding

```fish
set -g default_user "me" "buddy"
```

to your `config.fish`.

You can configure the date format by setting `theme_date_format` to a
[format string](http://fishshell.com/docs/current/cmds/date.html#format-string)
for the `date` command.

You can also set `theme_display_date`, or `theme_display_cmd_duration` to `no`
to disable the respective features.
