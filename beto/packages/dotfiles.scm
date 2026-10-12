;;; beto/packages/dotfiles.scm — first-run helpers for Guix AppVMs.
;;;
;;; Place yadm-bootstrap (the script) at beto/packages/aux-files/yadm-bootstrap.

(define-module (beto packages dotfiles)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages version-control)
  #:use-module (beto packages yadm))    ; adjust to wherever yadm is defined

(define-public yadm-bootstrap
  (package
    (name "yadm-bootstrap")
    (version "0.1")
    (source (local-file "aux-files/yadm-bootstrap"))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan #~'(("yadm-bootstrap" "bin/"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((bin (string-append #$output "/bin/yadm-bootstrap")))
                (chmod bin #o555)
                (wrap-program bin
                  `("PATH" prefix
                    ,(map (lambda (cmd)
                            (dirname (search-input-file inputs
                                                        (string-append "bin/" cmd))))
                          '("yadm" "git" "ssh" "mkdir"))))))))))
    (inputs (list bash-minimal coreutils git-minimal openssh yadm))
    (home-page "https://github.com/BetoHydroxyButyrate/guix-channel")
    (synopsis "First-run yadm dotfiles clone for a fresh AppVM")
    (description
     "@command{yadm-bootstrap} creates @file{~/proj} and clones the yadm
dotfiles repository over SSH, reporting (or with @option{--force},
overwriting) local files that differ from the repository.")
    (license license:gpl3+)))
