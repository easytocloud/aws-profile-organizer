# aws-profile-organizer

![release workflow](https://github.com/easytocloud/aws-profile-organizer/actions/workflows/release.yml/badge.svg)

Organize and switch between your AWS profiles easily, especially when dealing with multiple AWS organizations.

[... Keep the existing content ...]

## Tab Completion

aws-profile-organizer now supports tab completion for `awsenv` and `awsprofile` commands. This feature is automatically installed when you install the tool via Homebrew.

To enable tab completion:

- For Bash, add the following line to your `~/.bash_profile` or `~/.bashrc`:
  ```
  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  ```

- For Zsh, add the following line to your `~/.zshrc`:
  ```
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  ```

After adding the appropriate line, restart your shell or run `source ~/.bash_profile` (or `source ~/.zshrc` for Zsh) to enable tab completion.

Now you can use tab completion with `awsenv` and `awsprofile`. For example:
- Type `awsenv` and press Tab to see a list of available environments and options.
- Type `awsprofile` and press Tab to see a list of profiles in the current environment.

[... Keep the rest of the existing content ...]
