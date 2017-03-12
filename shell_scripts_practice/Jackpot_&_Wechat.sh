#!/bin/bash
#
let num=1
n1=(02 09 14 19 23 30 09)
n2=(03 07 12 18 22 31 09)
n3=(01 06 14 17 21 29 07)

RequestDrawn (){
ur=`curl -s http://f.apiplus.cn/ssq-1.xml|awk 'NR==3 {print $0}'`
state=`echo $ur|grep opencode`
RETVAL=$?
while [ $RETVAL -ne 0 ];do
	ur=`curl -s http://f.apiplus.cn/ssq-1.xml|awk 'NR==3 {print $0}'`
	state=`echo $ur|grep opencode`
	RETVAL=$?
done
}


TempCheck () {
	let jg=0
	[[ $1 == ${Dranum[0]} ]] && let jg=1000000 || let jg=0000000
	[[ $2 == ${Dranum[1]} ]] && let jg=$jg+100000 || let jg=$jg+000000
	[[ $3 == ${Dranum[2]} ]] && let jg=$jg+10000 || let jg=$jg+00000
	[[ $4 == ${Dranum[3]} ]] && let jg=$jg+1000 || let jg=$jg+0000
	[[ $5 == ${Dranum[4]} ]] && let jg=$jg+100 || let jg=$jg+000
	[[ $6 == ${Dranum[5]} ]] && let jg=$jg+10 || let jg=$jg+00
	[[ $7 == ${Dranum[6]} ]] && let jg=$jg+1 || let jg=$jg+0
}


CheckDrawn () {
if [[ `echo "$1"|grep -o 1|wc -l` == 7 ]];then
		res="一等奖,OMG准备好面具吧"
	elif  [[ `echo "$1"|grep -o 1|wc -l` == 6 ]];then
		if [[ `echo $1|cut -c 7` == 0 ]];then
			 res="二等奖,赶紧去彩票站，兑奖吧！"
		else
			 res="三等奖,中了3000元，不错的开始"
		fi
	elif [[ `echo "$1"|grep -o 1|wc -l` == 5 ]];then
		res="四等奖，恭喜中了200元，加油"
	elif [[ `echo "$1"|grep -o 1|wc -l` == 4 ]];then
		res="五等奖，十块也是钱"
	elif [[ `echo "$1"|grep -o 1|wc -l` == 0 ]];then
		res="未中奖，(你要习惯)"
	else
		of=`echo $1|wc -L`
		if [[ `echo $1|cut -c ${of}` == 0 ]];then
		     res="未中奖，(你要习惯)"
		else
		     res="六等奖，奖励一下"
		fi
fi
}

RequestDrawn

Dranum=(`echo $ur|sed -nr 's#^.*row.*" opencode="(.*)" open.*$#\1#gp'|sed -n 's#[,+]# #gp'`)
PeriNum=(`echo "$ur"|sed -nr 's/^.*row expect="(.*)" opencode.*$/\1/gp'`)
CropID="234"
Secret="_123"
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid 

=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\" '{print $4}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token 

=$Gtoken"

for i in "${n1[*]}"  "${n2[*]}" "${n3[*]}" ;do
	TempCheck $i
	CheckDrawn $jg
	/usr/bin/curl --data-ascii '{ "touser": "@all", "toparty": " @all ","msgtype": "text","agentid": "0","text": {"content": "开奖期数为'$PeriNum',本期中奖号码为'"${Dranum[*]}"'       您守号的第'$num'组号码为:                       '"$i"'       状态:'$res'"},"safe":"0"}' $PURL
let num=$num+1
done

