{ ... }: {
  programs.emacs = {
    enable = true;
    # extraConfig = ''
    #   ;; init package

    #   (require 'package)
    #   (package-initialize 'noactivate)
    #   (eval-when-compile
    #     (require 'use-package))

    #   ;; load some packages

    #   (use-package company
    #     :ensure t
    #     :bind ("<C-tab> . company-complete)
    #     :diminish company-mode
    #     :commands (company-mode global-company-mode)
    #     :defer 1
    #     :config
    #     (global-company-mode))

    #   (use-package magit
    #     :ensure t
    #     :defer
    #     :if (executable-find "git")
    #     :bind (("C-x g" . magit-status))
    #            ("C-x G" . magit-dispatch-popup))
    #     :init
    # '';
    extraPackages = epkgs: with epkgs; [
      company
      magit
      use-package
    ];
  };
}
