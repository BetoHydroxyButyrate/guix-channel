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
        (branch "main")
        (introduction
         (make-channel-introduction
          "cef6bf6d5d21e3250242a2b6ea02fd9a6ec791cf"
          (openpgp-fingerprint
           "9765 1FBD E504 F2D1 3DA9  88EB C0E8 4747 0C0B 2F22"))))
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
