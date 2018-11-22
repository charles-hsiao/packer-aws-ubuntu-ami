# packer-aws-ubuntu-ami

## Installation

### 1. Set-up AWS credentials
Please reference: [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

### 2. Install Packer: [Official Document](https://www.packer.io/intro/getting-started/install.html)
On Mac
```
brew install packer
```

On Ubuntu
```
# Download the latest precompiled binary, get the suitable package here: https://www.packer.io/downloads.html
# ex: https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip
wget ${PACKAGE_URL} 
# ex: packer_1.3.2_linux_amd64.zip
unzip ${PACKER_ZIP_FILE} 
```

### 3. Install jq: [Official Download website](https://stedolan.github.io/jq/download/)
On Mac
```
brew install jq
```

On Ubuntu
```
sudo apt-get install jq
```

### 4. Install gnu-sed (Only on Mac)
OSX's sed is BSD version. In order to align the sed command on Ubuntu GNU version, please install gnu-sed.
On Mac
```
brew install gnu-sed
``` 

