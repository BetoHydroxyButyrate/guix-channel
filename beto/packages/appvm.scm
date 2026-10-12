;;; beto/packages/appvm.scm — defaults for Qubes AppVMs built from a Guix
;;; template.  Meant to be listed by name in the template's extra packages
;;; (e.g. "beto-appvm-defaults"), so it lands in the system profile and every
;;; AppVM sees it with no per-AppVM state.

(define-module (beto packages appvm)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix search-paths)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages version-control)
  #:use-module (beto packages yadm))    ; adjust to wherever yadm is defined

(define-public beto-appvm-defaults
  (package
    (name "beto-appvm-defaults")
    (version "0.1")
    (source (local-file "aux-files/beto-appvm-defaults" #:recursive? #t))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan #~'(("bin" "bin")
                         ("etc" "etc"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((bin (string-append #$output "/bin/yadm-bootstrap")))
                (chmod bin #o555)
                (wrap-program bin
                  `("PATH" prefix
                    ,(map (lambda (cmd)
                            (dirname (search-input-file
                                      inputs (string-append "bin/" cmd))))
                          '("yadm" "git" "ssh" "mkdir"))))))))))
    (inputs (list bash-minimal coreutils git-minimal openssh yadm))
    ;; Export $profile/etc/xdg in XDG_CONFIG_DIRS, which is where Alacritty
    ;; (and other XDG-aware programs) find our system-wide defaults.
    (native-search-paths
     (list (search-path-specification
            (variable "XDG_CONFIG_DIRS")
            (files '("etc/xdg")))))
    (home-page "https://github.com/BetoHydroxyButyrate/guix-channel")
    (synopsis "Default configuration and first-run helpers for Guix AppVMs")
    (description
     "This package provides system-wide defaults for Qubes AppVMs based on a
Guix template: an Alacritty configuration under @file{etc/xdg}, which a
user's own configuration overrides, and @command{yadm-bootstrap}, which
creates @file{~/proj} and clones the yadm dotfiles repository over SSH.")
    (license license:gpl3+)))
