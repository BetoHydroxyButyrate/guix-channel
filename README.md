# guix-channel

Personal Guix channel: packages missing from upstream Guix.

| Package | Module |
| ------- | ------ |
| yadm    | `(beto packages yadm)` |

## Using it

Add to `~/.config/guix/channels.scm`:

```scheme
(cons* (channel
        (name 'beto)
        (url "https://github.com/BetoHydroxyButyrate/guix-channel")
        (branch "main"))
       %default-channels)
```

Then `guix pull && guix install yadm`, or in a Guix Home / system config:

```scheme
(use-modules (beto packages yadm))
```

To test a checkout without pulling:

```sh
guix build -L . yadm
```
