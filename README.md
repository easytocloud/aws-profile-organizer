# aws-profile-organizer
Organize your AWS profiles

## Description

AWS Profile Organizer is for those of you who maintain multiple sets of independent AWS profiles you might not want to combine in a single set of .aws/credentials and .aws/config files.

AWS CLI uses two files in ~/.aws to keep track of profiles that can be used on the commanline explicitely, like:

```
$ aws s3 ls --profile sandbox
```

or by use of setting the environment variable AWS_PROFILE (formerly AWS_DEFAULT_PROFILE)

```
$ export AWS_PROFILE=sandbox
$ aws s3 ls
```

In the examples above, sandbox is a reference to a profile that is configured in ~/.aws. There are two files used to define the profile.

## aws configure

You can use ``` aws configure``` to configure a profile. When no name is specified, it configures the profile named default, but other profiles can be configured in very
much the same way with `` aws configure --profile sandbox``. The command interactively asks for information that is stored in ~/.aws:


### credentials 

The file ~/.aws/credentials contains long-term credentials known as the Access Key Id and Secret Acces Key, which can be seen as the username/password for CLI operations.
Storing AK/SK in this credentials file is against best practice, but necessary in some cases.

~~~
[sandbox]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
~~~

### config

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

These variables are honoured by the CLI, but not all SDKs (for languages like node, python etc) use them accordingly. 

# Usecase
In a situation where you have access to different organizations, you should not combine profiles from different organizations in a single configuration. 
This is to reduce the risk of ever accidetely running commands in the wrong account.

aws-profile-organizer allows you to have different sets of profiles and easyly switch between them. 
You can (should?) display the current set in your prompt to further reduce the risk.

For that aws-profile-organizer intoduces the ``awsenv`` command. When invoked with a parameter it links the ~/.aws/credentials and ~/.aws/config files to the files of the environment of choice.
When invoked without a parameter it displays a list of available environments to choose from.

# Install
The tools are created for Mac OS but should run on other Unix-like systems with minor modifications, if any. Written for Mac, it works with zsh and uses Homebrew to install.

```shell
$ brew tap easytocloud/tap
$ brew install aws-profile-organizer
```

# Setup
Before you can switch between AWS environments, you would have to migrate your current setup with one ~/.aws/credentials and ~/.aws/config into an environment.

```
Sat Nov 12 09:08:06 CET 2022 - Setting up /Users/awscli/.zshrc for use with aws profile organizer
Please enter default environment name or ENTER for current value [default]: white
Sat Nov 12 09:08:18 CET 2022 - Moving your current settings into awsenv white
Sat Nov 12 09:08:18 CET 2022 - Setting your AWS_ENV to white
Sat Nov 12 09:08:18 CET 2022 - Setup completed
```

The screenshot above shows how a standard setup is converted into a setup with an environment white. 

The environments are stored in directories below ~/.aws/aws-envs where the name of the environment is the
name of the directory:

```
~/.aws/aws-envs
  + white/
    config
    credentials
  + red/
    config
    credentials
```
A single environment can contain multiple profiles. You can switch between profiles in an environment with awsprofile:

```
$ awsprofile sandbox
```

setup will add some lines to your .zshrc to set your default environment and profile. For that it uses to files:
```
~/.awsdefaultenv
~/.awsdefaultprofile
```
During login these files are processed to set the start environment and profile.

# Usage

```
$ awsenv white
$ awsprofile sandbox
```
The example above first sets the environment to white and then selects the sandbox profile from that environment. awsenv sets AWS_ENV (an aws-profile-organizer variable) whereas awsprofile sets AWS_PROFILE, honoured by AWS CLI.

When no argument is passed into awsenv or awsprofile, a list of available environments or profiles will be 
presented with the option to select one.

# NOTE
These tools were originally designed to work with cli version 1, but work with version 2 as well. 
CLI version 2 has support for sso and as such can do without long term credentials. 
Please refer cli documentation for further information.
