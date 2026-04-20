# jwks

Generates a [JWKS](https://datatracker.ietf.org/doc/html/rfc7517) (JSON Web Key Set) from an RSA key pair and publishes it as a static site via GitHub Pages at `/.well-known/jwks.json`.

## Prerequisites

- `openssl`
- [`uv`](https://github.com/astral-sh/uv) (for running the build script via `uvx`)

## Usage

### Generate keys and build JWKS

```sh
make
```

This generates `private_key.pem` and `public_key.pem` if they don't exist, then writes `public/.well-known/jwks.json`.

### Customize key ID and algorithm

```sh
make KID=my-key-1 ALG=RS256
```

Defaults: `KID=epic-test-key-1`, `ALG=RS384`.

### Bring your own keys

Place your existing `public_key.pem` in the repo root, then run:

```sh
make jwks
```

The private key is never required for JWKS generation — only the public key is read.

### Other targets

| Command | Description |
|---------|-------------|
| `make keys` | Generate RSA key pair only |
| `make jwks` | Build `public/.well-known/jwks.json` from existing public key |
| `make show` | Print current config and file status |
| `make clean` | Remove generated keys and `public/` directory |

## Deployment

Pushing to `main` triggers a GitHub Actions workflow that deploys the `public/` directory to GitHub Pages. The JWKS endpoint will be available at:

```
https://<username>.github.io/<repo>/.well-known/jwks.json
```

## Security

- `private_key.pem` and `public_key.pem` are gitignored — never commit them.
- Only the public key parameters (`n`, `e`) are included in the JWKS output.
