# helpme

## Tonton Jo  
### Join the community:
[![Youtube](https://badgen.net/badge/Youtube/Subscribe)](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)
[![Discord Tonton Jo](https://badgen.net/discord/members/h6UcpwfGuJ?label=Discord%20Tonton%20Jo%20&icon=discord)](https://discord.gg/h6UcpwfGuJ)
### Support my work, give a thanks and help the youtube channel:
[![Ko-Fi](https://badgen.net/badge/Buy%20me%20a%20Coffee/Link?icon=buymeacoffee)](https://ko-fi.com/tontonjo)
[![Infomaniak](https://badgen.net/badge/Infomaniak/Affiliated%20link?icon=K)](https://www.infomaniak.com/goto/fr/home?utm_term=6151f412daf35)
[![Express VPN](https://badgen.net/badge/Express%20VPN/Affiliated%20link?icon=K)](https://www.xvuslink.com/?a_fid=TontonJo)  
## Informations:
Thoses scripts aims to retreive usefull informations from my viewers in order to help them better.
It's not intended to get private informations, but as this is scripted, some may be unintentionnaly obtained.
No content will be uploaded or sent without your consent: Please check the content before sharing the file.

## docker_informations_retreiver.sh
### Sources:
https://gist.github.com/jonlabelle/8cbd78c9277e76cb21a142f0c556e939

### Used to:
- Get informations about a docker host and running container(s)
- Create a file with all thoses informations
- Allow you to upload it or not on file.io  
### How to:
#### Retreive informations about all running containers:
```shell
wget -qO docker_informations_retreiver.sh https://github.com/Tontonjo/helpme/raw/main/docker_informations_retreiver.sh && bash docker_informations_retreiver.sh
```  

#### OR retreive informations about one or more containers:
- Find your $containername
```shell
docker stats --all
```
```shell
wget -q -N https://github.com/Tontonjo/helpme/raw/main/docker_informations_retreiver.sh 
```
```shell
bash docker_informations_retreiver.sh $containername $container2
```
