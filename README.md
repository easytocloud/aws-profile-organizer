# aws-profile-organizer
Organize your AWS profile

AWS Profile Organizer is for those of you who maintain multiple set of AWS profiles you might not want to combine in a single set of .aws/credentials and .aws/config files.

The organizer organizes sets of files and sym-links the actual set to ~/.aws/credentials and ~/.aws/config. After the symlink is installed you can use your 
AWS cli in the standard way.

# Install

# Setup

# Usage

AWS Profile Organizer installs in your .aws directory and creates a number of shell functions. These functions have to be sourced as part of your login,
for instance by adding them to your ~/.bash profile.

$ awsenv

$ awsprofile

