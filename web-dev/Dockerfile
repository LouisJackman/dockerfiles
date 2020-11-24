FROM base-dev

RUN [ \
    "npm", \
    "install", \
    "--global", \
    "eslint@7.14.0", \
    "prettier@2.2.0", \
    "typescript@4.1.2", \
    "stylelint-lsp@1.0.6", \
    "create-react-app@4.0.0" \
]

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +'CocInstall -sync coc-emmet coc-css coc-eslint coc-html coc-tsserver' +quitall

WORKDIR /home/dev/src

