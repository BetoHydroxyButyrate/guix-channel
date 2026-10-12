(define-module (beto packages yadm)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control))

(define-public yadm
  (package
    (name "yadm")
    (version "3.5.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/yadm-dev/yadm")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00gm0frsh5vlq3zj5pg36awp6lg7hgklgbvb59hr6splrv73lfl4"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("yadm"                      "bin/")
          ("yadm.1"                    "share/man/man1/")
          ("completion/bash/yadm"      "share/bash-completion/completions/")
          ("completion/zsh/_yadm"      "share/zsh/site-functions/")
          ("completion/fish/yadm.fish" "share/fish/vendor_completions.d/"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap-runtime-deps
            (lambda* (#:key inputs #:allow-other-keys)
              (wrap-program (string-append #$output "/bin/yadm")
                `("PATH" suffix
                  ,(map (lambda (cmd)
                          (dirname (search-input-file inputs
                                                      (string-append "bin/" cmd))))
                        '("git" "gpg" "openssl" "gawk")))))))))
    (inputs (list bash-minimal git gnupg openssl gawk))
    (home-page "https://yadm.io/")
    (synopsis "Yet Another Dotfiles Manager")
    (description
     "yadm is a dotfiles manager built on Git.  It adds alternate files per
host/OS/class, templating, encryption of private files, and bootstrap hooks.")
    (license license:gpl3+)))
