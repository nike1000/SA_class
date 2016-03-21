#!/bin/sh
##0456085 kshuang 2015/11/19 @SA

ce=$(echo $'\xe2\x84\x83')
fa=$(echo $'\xe2\x84\x89')


if test -e 'weather.conf' ; then
{
  location=$(awk -F "=" '{if($0 ~ /location/){print $2}}' weather.conf)
  unit=$(awk -F "=" '{if($0 ~ /unit/){print $2}}' weather.conf)
  forcast=$(awk -F "=" '{if($0 ~ /forcast/){print $2}}' weather.conf)
}
fi
if test -z $unit;then
{
  unit="f"
}
fi


d=$forcast
if test -z $forcast;then
{
  d=0
}
fi

c=0
s=0

query="?"
url="http://weather.yahooapis.com/forecastrss"

result_local=""
result_day1=""
result_day2=""
result_day3=""
result_day4=""
result_day5=""
result_cur=""
result_sun=""

###############Function###################

##information to user
usage()
{
  echo -e "./weather -l locations [-u unit] [ -a | -c | -d day | -s ]"
  echo -e "unit should be f for Fahrenheit or c for Ceilsius"
  echo -e "a equal -c -s -d 5"
  echo -e "c for current codition"
  echo -e "d for forecast, day should be 1~5"
  echo -e "s for sunrise/sunset"
  exit
}

get_location()
{
  result_local=$(echo $output | awk -F ";" '{print $1}')
  result_local=$(echo $result_local | awk -F "\"" '{print $2}')
}

get_sun()
{
  result_sun=$(echo $output | awk -F ";" '{print $2}')
  result_sun=$(echo $result_sun | awk -F "\"" '{print "sunrise: " $2 ", sunset: " $4}')
}

get_current()
{
  result_cur=$(echo $output | awk -F ";" '{print $3}')
  result_cur=$(echo $result_cur | awk -F "\"" '{print $2 ", " $6}')
  if [ $unit = "c" ]; then
  {
    result_cur="$result_local, $result_cur$ce"
  }
  elif [ $unit = "f" ]; then
  {
    result_cur="$result_local, $result_cur$fa"
  }
  else
  {
    usage
  }
  fi
}

get_day1()
{
  result_day1=$(echo $output | awk -F ";" '{print $4}')
  if [ $unit = "c" ]; then
  {
    result_day1=$(echo $result_day1 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$ce/g")
  }
  elif [ $unit = "f" ]; then
  {
    result_day1=$(echo $result_day1 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$fa/g")
  }
  else
  {
    usage
  }
  fi 
}

get_day2()
{
  result_day2=$(echo $output|awk -F ";" '{print $5}')
  if [ $unit = "c" ]; then
  {
    result_day2=$(echo $result_day2 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$ce/g")
  }
  elif [ $unit = "f" ]; then
  {
    result_day2=$(echo $result_day2 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$fa/g")
  }
  else
  {
    usage
  }
  fi
}

get_day3()
{
  result_day3=$(echo $output|awk -F ";" '{print $6}')
  if [ $unit = "c" ]; then
  {
    result_day3=$(echo $result_day3 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$ce/g")
  }
  elif [ $unit = "f" ]; then
  {
    result_day3=$(echo $result_day3 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$fa/g")
  }
  else
  {
    usage
  }
  fi

}

get_day4()
{
  result_day4=$(echo $output|awk -F ";" '{print $7}')
  if [ $unit = "c" ]; then
  {
    result_day4=$(echo $result_day4 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$ce/g")
  }
  elif [ $unit = "f" ]; then
  {
    result_day4=$(echo $result_day4 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$fa/g")
  }
  else
  {
    usage
  }
  fi

}

get_day5()
{
  result_day5=$(echo $output|awk -F ";" '{print $8}')
  if [ $unit = "c" ]; then
  {
    result_day5=$(echo $result_day5 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$ce/g")
  }
  elif [ $unit = "f" ]; then
  {
    result_day5=$(echo $result_day5 | awk -F "\"" '{print $4 " " $2 " " $6 "; ~ " $8 "; " $10}' | sed -e "s/;/$fa/g")
  }
  else
  {
    usage
  }
  fi
}


##根據使用者輸入的參數決定要顯示多少內容
output()
{
  if [ $c -eq 1 ]; then
  {
    echo -e $result_cur
  }
  fi

  if [ $d -ge 5 ]; then
  {
    echo -e $result_day1"\n"$result_day2"\n"$result_day3"\n"$result_day4"\n"$result_day5
  }
  elif [ $d -eq 4 ]; then
  {
    echo -e $result_day1"\n"$result_day2"\n"$result_day3"\n"$result_day4
  }
  elif [ $d -eq 3 ]; then
  {
    echo -e $result_day1"\n"$result_day2"\n"$result_day3
  }
  elif [ $d -eq 2 ]; then
  {
    echo -e $result_day1"\n"$result_day2
  }
  elif [ $d -eq 1 ]; then
  {
    echo -e $result_day1
  }
  fi
  if [ $s -eq 1 ]; then
  {
    echo -e $result_sun
  }
  fi

  echo -e ""
}

##############################Code Flow####################################

while getopts hl:u:acsd: op ; do
{
  case $op in
  l)
    location=$OPTARG ;;
  u)
    unit="$OPTARG"
    query=$query"u="$unit"&" ;;
  a)
    c=1
    d=5
    s=1 ;;
  c)
    c=1 ;;
  s)
    s=1 ;;
  d)
    d=$OPTARG ;;
  *)
    usage ;;
  esac
}
done

##arg check
if test -z $location; then
{
  echo -e "Must specify location\n./weather -l locations [-u unit] [ -a | -c | -d day | -s ]\n"
  exit
}
fi

arg_sum=$((c+d+s))
if [ $arg_sum -eq 0 ]; then
{
  echo -e "Must specify type of information\n./weather -l locations [-u unit] [ -a | -c | -d day | -s ]\n"
  exit
}
fi


##多城市處理
city_count=$(echo $location | awk -F "," '{print NF}')
i=1
while [ $i -le $city_count ]; do
{
  city=$(echo $location | awk -v count="$i" '{if(NR==count)print $0}' RS=',')
  
  ##從city name 取得 woeid
  woeid=$(curl -s https://query.yahooapis.com/v1/public/yql -d q="select woeid from geo.places where text='$city'" -d format='json'| awk -F ":" '{print $10}' | sed -e 's/"//g' -e 's/}.*$//g')

  query_arg=$query"w="$woeid
  ##

  ##取得YAHOO weather資料，parse出需要片段
  output=$(curl -s $url$query_arg | awk \
  '{
    if($1 ~ /^<yweather:location/)
    {
      result_local=$0
    }
    if($1 ~ /^<yweather:astronomy/)
    {
      result_sun=$0
    }
    if($1 ~ /^<yweather:condition/)
    {
      result_cur=$0
    }
    if($1 ~ /^<yweather:forecast/)
    {
      result_day=result_day $0 ";"
    }
  }

  END{
    print result_local ";" result_sun ";" result_cur ";" result_day
  }')
 
  get_location
  get_sun
  get_current
  get_day1
  get_day2
  get_day3
  get_day4
  get_day5

  output

  i=$(($i+1))
}
done
