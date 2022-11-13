# aws-profile-organizer
Organize and change between your AWS profiles easily

### Background
In a situation where you have access to different AWS organizations, 
you should NOT combine their profiles for CLI operations in a single configuration. 
This is to prevent executing AWS commands in the wrong account.

<em>Introducing aws-profile-organizer</em>

With aws-profile-organizer you combine profiles in environments and change between environments and profiles with ease.

## Installation
The tools are created for Mac OS but should run on other Unix-like systems with minor modifications, if any. 
Written for Mac OS, it works with zsh and uses Homebrew to install.

```shell
brew tap easytocloud/tap
brew install aws-profile-organizer
```

## Environments
aws-profile-organizer organizes your profiles in environments.

For that aws-profile-organizer intoduces the ``awsenv`` and ``awsprofile`` commands. 

### awsenv
When invoked with a the name of an environment as argument, this environment becomes active. 

```
$ awsenv white
```

When invoked without an environment name, it displays a list of available environments to choose from.
```
$ awsenv
1 red       2 white
Enter environment number [1-2]> _
```
The selected environment becomes active. 

When invoked with --init and a name, it creates a new environment with that name and makes it active.

```
$ awsenv --init blue
2022/11/12-13:43 - environment blue created and active
```

To switch between profiles in an environment, use awsprofile.
To manage profiles within an environment, use standard aws cli's ```aws configure```.

**NOTE** When activating an environment, awsenv creates symbolic links from the ~/.aws/credentials and ~/.aws/config files to the corresponding files in the environment of choice.
Environments are kept in ~/.aws/aws-envs in directories named after the environment.

You should probablydisplay the current environment and profile in your prompt. 
If you already use zsh and oh-my-zsh, why not have a look at our agnoster-based [oh-my-easytocloud](https://github.com/easytocloud/oh-my-easytocloud) prompt.

## Profile selection
AWS CLI uses two files in ~/.aws to store profiles. Profiles can be used on the commanline explicitely, like:

```
$ aws s3 ls --profile sandbox
```

or by use of setting the environment variable AWS_PROFILE (formerly AWS_DEFAULT_PROFILE)

```
$ export AWS_PROFILE=sandbox
$ aws s3 ls
```

In the examples above, sandbox is a reference to a profile that is configured in ~/.aws. See AWS cli documentation for more information about profiles.

### awsprofile
When a valid profile name is passed as argument, the AWS_PROFILE variable is set quietly.

```
$ awsprofile sandbox
$ echo $AWS_PROFILE
sandbox
```

When no profile name is provided,
awsprofile lets you pick a profile from the profiles in your configuration and sets AWS_PROFILE (as used by AWS CLI).

```
$ awsprofile
1 sandbox    2 development     3 production
Enter profile number [1-3]> 2
$ echo $AWS_PROFILE
development
```

### aws configure
You can use ```aws configure``` (part of aws-cli) to configure a profile. 
When no profile name is specified, it configures the profile named default, 
but other profiles can be configured in very much the same way:

```
aws configure --profile sandbox
```

The command interactively asks for information that is stored in ~/.aws. 

aws-profile-organizer doesn't change this standard behaviour.

## Files
The two files that make a profile are

### ~/.aws/credentials 
The credentials file contains long-term credentials known as the Access Key Id and Secret Acces Key, which can be seen as the username/password for CLI operations.
Storing AK/SK in this credentials file is against best practice, but necessary in some cases - notably before version 2 of the CLI.
With CLI version 2, have a look at ```aws sso login``` as an alternative.

~~~
[sandbox]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
~~~

### ~/.aws/config
The config file holds all other-than-credentials information about a profile, the likes of a region, default output etc.

~~~
[profile sandbox]
region=eu-west-1
output=yaml
~~~

## CLI vs SDK

The CLI uses the configuration files mentioned above OR alternative files that can be set using environment variables:

```
AWS_CONFIG_FILE=~/.aws/config
AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
```

However, these variables are honoured by the CLI, but not all SDKs (for languages like node, python etc) use them accordingly. 

## Initial Setup
Before you can switch between AWS environments, you have to migrate your current setup with one ~/.aws/credentials and ~/.aws/config into an environment.
```
aws-profile-organizer-setup
```
This moves your current single configuration into a named environment. This is a one-time operation.
```
$ *aws-profile-organizer-setup*
Sat Nov 12 09:08:06 CET 2022 - Setting up /Users/awscli/.zshrc for use with aws profile organizer
Please enter default environment name or ENTER for current value [default]: **white**
Sat Nov 12 09:08:18 CET 2022 - Moving your current settings into awsenv white
Sat Nov 12 09:08:18 CET 2022 - Setting your AWS_ENV to white
Sat Nov 12 09:08:18 CET 2022 - Setup completed
```

The screenshot above shows how a standard setup is converted into a setup with an environment named white. 

The environments are stored in directories below ~/.aws/aws-envs where the name of the environment is the
name of the directory:

```yaml
~/.aws/aws-envs
  - white
    - config
    - credentials
```

setup will add some lines to your .zshrc to set your default environment and profile. For that it uses two files:
```
~/.awsdefaultenv
~/.awsdefaultprofile
```
During login these files are processed to set the start environment and profile. 
You can use your favourite editor to edit the files. Both should just contain the name of the environment and profile respectively.

## Usage

```
$ awsenv white
```
activates the environment white and *the first profile* in its definition becomes acative.
```
$ awsprofile sandbox
```
The example above selects the sandbox profile from the active environment. awsenv sets AWS_ENV (an aws-profile-organizer variable) whereas awsprofile sets AWS_PROFILE, honoured by AWS CLI.

When no argument is passed into awsenv or awsprofile, a list of available environments or profiles will be 
presented with the option to select one.

# NOTE
These tools were originally designed to work with cli version 1, but work with version 2 as well. 
CLI version 2 has support for sso and as such can do without long term credentials. 
Please refer cli documentation for further information.
