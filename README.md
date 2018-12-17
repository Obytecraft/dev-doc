# Setup

## Naming Convention
Follow these conventions for your readme files to be rendered. 
Change the name of your Readme files to conform with these conventions. 
Example: 
`_dev-kit.md` 

All `md` files which will be added should be `_*.md`.

***
Kindly follow the [Slate](https://github.com/lord/slate/wiki/Markdown-Syntax) Markdown syntax
***

## Usage / Contribution

1. Clone the project `git clone http://gitlabchina.subsidia.org/ooseifrimpong/dev-induction.git`
2. Create your feature branch: `git checkout -b my-new-feature`
3. Find the md file under `source/includes/`
4. Check if your project's readme already exist.
5. If it exists, edit the readme and go `step 7.`
6. If not exists, create a new readme file following the naming conventions above.
7. Stage all changes `git add --all` 
8. Commit your changes: `git commit -am 'Add some feature'` 
9. Push to the branch: `git push origin my-new-feature`
10. Submit a pull request to merge with `develop branch` :D


## How to add custom Readme 

You can add 

1. Create an `_*.md` file in the `/source/includes/` folder.
2. To get it to render you need to include it in `/source/dev-doc/index.md` file.
3. Make sure it's under the `includes:` section.

## How to test before pushing
**Note: Project is based on Ruby**
1. Run `bundle install`
2. Run `bundle exec middleman build`
3. Open `index.html` file found in `/build/dev-doc/` in your preferred browser.
