# direnv-dotenvx

A simple direnv extension to automatically load environment variables from `.env` files using
[dotenvx](https://dotenvx.com/).

## 📦 Installation

1. Clone the repo somewhere:

```sh
mkdir -p ~/.config/direnv/lib
git clone https://github.com/chenasraf/direnv-dotenvx ~/.config/direnv/lib/direnv-dotenvx
```

2. Symlink or source the loader:

```sh
ln -s ~/.config/direnv/lib/direnv-dotenvx/use_dotenvx.sh ~/.config/direnv/lib/use_dotenvx.sh
```

✅ This makes the function `use_dotenvx` available in all `.envrc` files.

## ⚙️ Usage

In your `.envrc`:

```sh
use_dotenvx              # loads .env or .env.default
use_dotenvx dev          # loads .env.dev
```

Then run:

```sh
direnv allow
```

## 🔒 Security Note

> ⚠️ `direnv` applies only explicitly exported variables from the `.envrc` environment. `dotenvx`
> handles `.env` files without needing `export` statements, so your `.env` or `.env.*` files should
> use the standard `KEY=value` format. Always review your environment files before allowing `direnv`
> to apply them, as they affect your local shell environment.

## 📝 License

MIT

## Contributing

I am developing this package on my free time, so any support, whether code, issues, or just stars is
very helpful to sustaining its life. If you are feeling incredibly generous and would like to donate
just a small amount to help sustain this project, I would be very very thankful!

<a href='https://ko-fi.com/casraf' target='_blank'>
  <img height='36' style='border:0px;height:36px;'
    src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3'
    alt='Buy Me a Coffee at ko-fi.com' />
</a>

I welcome any issues or pull requests on GitHub. If you find a bug, or would like a new feature,
don't hesitate to open an appropriate issue and I will do my best to reply promptly.

