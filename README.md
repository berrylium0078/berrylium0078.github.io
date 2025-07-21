# blog-starter

This repository stores configuration and source files for my Hexo blog.

## Features

This blog uses the Hexo theme *Butterfly*, with the addition of *hexo-theme-pandoc* for extended Markdown syntax support and *hexo-filter-mathjax* for server-side rendering of mathematical formulas.

- The default font for code blocks is *Fira Code*, a font supports ligature.
  - To customize, you need to edit `font.code_font_family` and inject the CSS copied from Google Fonts.
- Code blocks use the Catppuccin Latte / Mocha color schemes for day and night modes, respectively.
  - Refer to `source/self/catppuccin-latte-mocha.css` and the tutorial [Customize code coloring](https://butterfly.js.org/en/posts/customize-code-coloring/).
- There is a single-repository Github Pages Deployment Workflow, relieving you from the burden of static file generation.

## Quick Start

Make sure that you have `git`, `npm` and `pandoc` installed.

```sh
# Install Hexo CLI globally
# npm install -g hexo-cli

# Clone the starter
$ git clone https://github.com/berrylium0078/blog-starter blog
$ cd blog

# Install dependencies and start the local server
$ npm install
$ hexo s
```

## Deploy to Github Pages

Create a repository on Github, named `<owner>.github.io`.

Then execute:
```sh
git remote set-url origin git@github.com:<owner>/<owner>.github.io.git
git push origin main
```
To upload your site to Github.

The repo contains a pre-configured Github Workflow, which generates the static files and deploy to Pages on push.
All you need to do is to configure your site to publish with GitHub Actions.

[Publishing with a custom GitHub Actions workflow](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow)
