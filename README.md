# blog-starter

This repository contains the configuration and source files for my Hexo blog.

## Features

This blog uses the Hexo theme *Butterfly*, with the addition of *hexo-renderer-pandoc* for extended Markdown syntax support and *hexo-filter-mathjax* for server-side rendering of mathematical formulas.

Additional features include:
- A single-repository Github Pages deployment workflow, eliminating the need to manually generate static files.
- Code blocks use the *Fira Code* font, which supports ligatures.
- Catppuccin Latte and Mocha color schemes for code blocks in light and dark modes, respectively.

Fixes and enhancements:
- Added scroll margin for equation tags inside math blocks.
- Auto-generated anchor links for section titles, via Pandoc Lua filter.

## Quick Start

Make sure that you have `git`, `npm` and `pandoc` installed.

```sh
# Install Hexo CLI globally
# npm install -g hexo-cli

# Clone the starter
$ git clone https://github.com/berrylium0078/berrylium0078.github.io --branch=starter blog
$ cd blog

# Install dependencies and start the local server
$ npm install
$ hexo s
```

## Deploy to Github Pages

Create a repository on Github, named `<owner>.github.io`.

> [!TIP]
> Don’t forget to update the `url` field in your `_config.yml` to match your GitHub Pages domain, e.g., https://<owner>.github.io.

> [!CAUTION]
> Avoid using a [project site](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories#types-of-github-pages-sites),
as the root path `/` will map to `http(s)://<owner>.github.io` instead of `http(s)://<owner>.github.io/<repo>`.

The repository includes a out-of-the-box workflow to publish the site. All you need to do is to configure your site to [Publish with GitHub Actions](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow).

Finally, run:
```sh
git remote set-url origin git@github.com:<owner>/<owner>.github.io.git
git push origin main
```

This will push your site to GitHub, and the workflow will automatically generate static files and deploy them to GitHub Pages.

## Customize

If you are not satisfied with my tweaks, here are the related materials:

- Files:
  - `_config.yml`, `_config.butterfly.yml`
  - `.github/workflow/*`
  - `source/css/*`
  - `pandoc/*`
- Theme *Butterfly* tutorials:
  - [Customize code coloring](https://butterfly.js.org/en/posts/customize-code-coloring/).
  - [Customize Fonts](https://butterfly.js.org/en/posts/butterfly-docs-en-theme-config/#Custom-Fonts-and-Font-Sizes).
  - [Inject](https://butterfly.js.org/en/posts/butterfly-docs-en-theme-config/#Inject).

And note that in order to use web fonts, you need to inject the css from Google/Adobe Fonts.
