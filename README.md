# aws-profile-organizer

![release workflow](https://github.com/easytocloud/aws-profile-organizer/actions/workflows/release.yml/badge.svg)

Organize and switch between your AWS profiles easily, especially when dealing with multiple AWS organizations.

## Problem Statement

Managing multiple AWS profiles across different AWS organizations can be challenging and potentially risky. Users often find themselves juggling numerous profiles, which can lead to:

- Confusion about which profile is currently active
- Risk of executing AWS commands in the wrong account
- Difficulty in organizing and managing credentials for different organizations

## Solution

aws-profile-organizer solves these problems by:

1. Organizing AWS profiles into separate "environments" (typically representing different AWS organizations)
2. Providing simple commands to switch between environments and profiles
3. Ensuring clear separation of credentials and configurations across different organizations

## Quick Start

```shell
# Install the tool
brew tap easytocloud/tap
brew install aws-profile-organizer

# Set up your first environment
aws-profile-organizer-setup

# Switch to an environment
awsenv my-org-1

# Switch to a profile within the current environment
awsprofile dev-account
```

## Key Concepts

- **Environment**: A collection of AWS profiles, typically representing a single AWS organization
- **awsenv**: Command to switch between environments
- **awsprofile**: Command to switch between profiles within the current environment

## How It Works

1. Environments are stored in `~/.aws/aws-envs`, with each environment in its own directory
2. `awsenv` sets `AWS_SHARED_CREDENTIALS_FILE` and `AWS_CONFIG_FILE` to point to the selected environment and symlinks credentials and config files
3. `awsprofile` sets `AWS_PROFILE` to select a specific profile within the current environment
4. It's recommended to use a prompt that displays the current environment and profile, like the `oh-my-easytocloud` theme for `oh-my-zsh` (available at [oh-my-easytocloud](https://github.com/easytocloud/oh-my-easytocloud))

## Installation

The tools are created for macOS but should run on other Unix-like systems with minor modifications.

```shell
brew tap easytocloud/tap
brew install aws-profile-organizer
```

## Usage

### Understanding awsenv

`awsenv` is a powerful command that manages your AWS environments. Here's a detailed explanation of its functionality:

1. **Environment Management**: `awsenv` allows you to create, switch between, and manage separate AWS environments. Each environment typically represents a distinct AWS organization or a set of related AWS accounts.

2. **Configuration File Handling**: When you switch environments using `awsenv`, it updates the `AWS_SHARED_CREDENTIALS_FILE` and `AWS_CONFIG_FILE` environment variables. These variables point to the credentials and config files specific to the selected environment.

3. **Symlink Creation**: `awsenv` creates symbolic links from `~/.aws/credentials` and `~/.aws/config` to the corresponding files in the selected environment's directory. This ensures that AWS CLI and SDKs use the correct configuration for the active environment.

4. **Environment Variable**: `awsenv` sets the `AWS_ENV` environment variable to the name of the current environment. This allows other scripts or tools to be aware of the active AWS environment.

5. **Profile Management**: While `awsenv` manages environments, it works in conjunction with `awsprofile` to manage individual profiles within an environment. After switching environments with `awsenv`, you can use `awsprofile` to select a specific profile within that environment.

### Setting Up Environments

```shell
$ awsenv --init my-org-1
2022/11/12-13:43 - environment my-org-1 created and active
```

### Switching Environments

```shell
$ awsenv my-org-1
```

or

```shell
$ awsenv
1 my-org-1    2 my-org-2
Enter environment number [1-2]> _
```

### Switching Profiles

After selecting an environment with `awsenv`, use `awsprofile` to switch between profiles within that environment:

```shell
$ awsprofile dev-account
```

or

```shell
$ awsprofile
1 dev-account    2 prod-account    3 sandbox
Enter profile number [1-3]> _
```

When no argument is passed into `awsenv` or `awsprofile`, a list of available environments or profiles will be presented with the option to select one.

## File Structure

```
~/.aws/aws-envs/
  - my-org-1/
    - config
    - credentials
  - my-org-2/
    - config
    - credentials
```

## Advanced Usage and Configuration

### Profile Selection
AWS CLI uses two files in ~/.aws to store profile definitions. 
Profiles can be used on the command line explicitly, like:

```
$ aws s3 ls --profile sandbox
```

or by setting the environment variable AWS_PROFILE (formerly AWS_DEFAULT_PROFILE):

```
$ export AWS_PROFILE=sandbox
$ aws s3 ls
```

In both examples above, sandbox is a reference to a profile that is configured in ~/.aws. 
See AWS CLI documentation for more information about profiles.

### aws configure
You can use `aws configure` (part of aws-cli) to configure a profile. 
When no profile name is specified, it configures the profile named default, 
but other profiles can be configured in very much the same way:

```
aws configure --profile sandbox
```

The command interactively asks for information that is stored in ~/.aws. 

aws-profile-organizer doesn't change this standard behavior.

## Files
The two files that make a profile are:

### ~/.aws/credentials 
The credentials file contains long-term credentials known as the Access Key Id and Secret Access Key (AK/SK) for an IAM *user*, which can be seen as the username/password for CLI operations.
```
[sandbox]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

> NOTE: Storing AK/SK in this credentials file is against best (security) practices, but necessary in some cases - notably before version 2 of the CLI.
With CLI version 2, have a look at `aws sso login` as an alternative.

### ~/.aws/config
The config file holds all other-than-credentials information about a profile, such as region, default output, etc.

```
[profile sandbox]
region=eu-west-1
output=yaml

[profile sandbox-us]
region=us-east-1
source_profile=sandbox

[profile admin-role]
source_profile=sandbox
role_arn=arn:aws:iam:123123123123::role/admin-role
```

The config file above describes 3 profiles, all referencing the same (IAM User) profile in the credentials file. 
What makes `admin-role` a role is that it has a role arn in its definition.

> TIP: Store IAM user credentials in the credentials file and use the config file to store all other config items and roles that can be assumed using the credentials from the credentials file.

Remember, a role doesn't have credentials itself; it references an IAM user as per source_profile. It is the IAM user that **assumes** the role. 
Both the user (with AK/SK credentials) and the role it assumes have to be configured for the CLI to use the role.
Any config block in the config file either has a name that also appears in the credentials file (implicit reference) or explicitly references a source profile in the credentials file.

## CLI vs SDK

The CLI uses the configuration files mentioned above OR alternative files that can be set using environment variables:

```
AWS_CONFIG_FILE=~/.aws/config
AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
```

However, these variables are honored by the CLI, but not all SDKs (for languages like Node.js, Python, etc.) use them accordingly. 

## Initial Setup
Before you can switch between AWS environments, you have to migrate your current setup with one ~/.aws/credentials and ~/.aws/config into an environment.
```
aws-profile-organizer-setup
```
This moves your current single configuration into a named environment. This is a one-time operation.
```
$ aws-profile-organizer-setup
Sat Nov 12 09:08:06 CET 2022 - Setting up /Users/awscli/.zshrc for use with aws profile organizer
Please enter default environment name or ENTER for current value [default]: white
Sat Nov 12 09:08:18 CET 2022 - Moving your current settings into awsenv white
Sat Nov 12 09:08:18 CET 2022 - Setting your AWS_ENV to white
Sat Nov 12 09:08:18 CET 2022 - Setup completed
```

The example above shows how a standard setup is converted into a setup with an environment named white. 

The environments are stored in directories below ~/.aws/aws-envs where the name of the environment is the
name of the directory:

```yaml
~/.aws/aws-envs
  - white
    - config
    - credentials
```

The setup will add some lines to your .zshrc to set your default environment and profile. For that it uses two files:
```
~/.awsdefaultenv
~/.awsdefaultprofile
```
During login, these files are processed to set the start environment and profile. 
You can use your favorite editor to edit the files. Both should just contain the name of the environment and profile respectively.

## Note
This tool was originally designed to work with CLI version 1 but works with version 2 as well. 
CLI version 2 has support for SSO and as such can do without long-term credentials. 
Consider using [sso-tools](https://github.com/easytocloud/sso-tools) as well, also available from easytocloud in our HomeBrew tap. The sso-tools provide additional functionality for working with AWS SSO (Single Sign-On) environments.

## Contributing

Feel free to fork and create a Pull Request.

## License

This code is licensed under the [MIT License](https://opensource.org/licenses/MIT).

