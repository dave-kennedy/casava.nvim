# CaSaVa

A CSV file formatter for Neovim, written in Lua.

## Usage

Say your active buffer contains this:

```
Name, Tagline, Score
Gypsy, They're going to kill Joel!, 1
Joel Robinson, "If you don't understand it, shoot it.", 300
"Robot, Crow T.", I use cyber-based bubble memory, 180
Tom Servo, You are how you look. Me? I'm a gumball machine!, "714,083"
"Nelson, Mike", "Please be careful, this will be boring.", "1,234"
```

Just call `:CsvAlign` and voila:

```csv
Name            ,Tagline                                         ,Score
Gypsy           ,They're going to kill Joel!                     ,1
Joel Robinson   ,"If you don't understand it, shoot it."         ,300
"Robot, Crow T.",I use cyber-based bubble memory                 ,180
Tom Servo       ,You are how you look. Me? I'm a gumball machine!,"714,083"
"Nelson, Mike"  ,"Please be careful, this will be boring."       ,"1,234"
```

## Install

With [lazy.nvim](https://lazy.folke.io/) prior to v11:

```lua
require('lazy').setup({
    {
        'dave-kennedy/casava.nvim',
        config = function ()
            require('casava')
        end
    }
})
```

After v11 with the [single file setup](https://lazy.folke.io/installation):

```lua
require('lazy').setup({
    spec = {
        {
            'dave-kennedy/casava.nvim',
            config = function ()
                require('casava')
            end
        }
    }
})
```

If you followed the structured setup instructions instead, create a file at
`~/.config/nvim/lua/plugins/casava.lua` with these contents:

```lua
return {
    'dave-kennedy/casava.nvim',
    opts = {}
}
```

## Development

Clone this repo, then change `'dave-kennedy/casava.nvim'` in your plugin spec
to `dir = 'path/to/casava.nvim'`.

## TODO

* Add config options
    * Alternate escape characters
    * Alternate field delimiters
* Sort on column
* Unit tests
