# helpme

## Tonton Jo - 2021  
### Join the community:
[![Youtube channel](https://github-readme-youtube-stats.herokuapp.com/subscribers/index.php?id=UCnED3K6K5FDUp-x_8rwpsZw&key=AIzaSyA3ivqywNPQz0xFZBHfPDKzh1jFH5qGD_g)](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)
[![Discord Tonton Jo](https://badgen.net/discord/members/2NQskxZjfp?label=Discord%20Tonton%20Jo%20&icon=discord)](https://discord.gg/2NQskxZjfp)
### Support the channel with one of the following link:
[![Ko-Fi](https://badgen.net/badge/Buy%20me%20a%20Coffee/Link?icon=buymeacoffee)](https://ko-fi.com/tontonjo)
[![Infomaniak](https://badgen.net/badge/Infomaniak/Affiliated%20link?icon=K)](https://www.infomaniak.com/goto/fr/home?utm_term=6151f412daf35)
[![Express VPN](https://badgen.net/badge/Express%20VPN/Affiliated%20link?icon=K)](https://www.xvuslink.com/?a_fid=TontonJo)  
## Informations:
Thioses scripts aims to retreive usefull informations from my viewers in order to help them better.
It's not intended to get private informations, but as this is scripted, some may be unintentionnaly obtained.
No content will be uploaded or sent without your consent: Please check the content before sharing the file.

## docker_informations_retreiver.sh
### Sources:
https://gist.github.com/jonlabelle/8cbd78c9277e76cb21a142f0c556e939

### Used to:
get informations about a docker host and running container(s)
### How to:
Execute script and retreive informations about all running containers:
```shell
wget -q -O - https://github.com/Tontonjo/helpme/raw/main/docker_informations_retreiver.sh | bash
```  
Execute script and retreive informations about one or more containers:
```shell
wget -q -N -O https://github.com/Tontonjo/helpme/raw/main/docker_informations_retreiver.sh 
```
```shell
bash docker_informations_retreiver.sh CONTAINER1 CONTAINER2
```
