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
