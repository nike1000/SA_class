#!/bin/sh

a11=0
a12=0
a13=0
a14=0
a21=0
a22=0
a23=0
a24=0
a31=0
a32=0
a33=0
a34=0
a41=0
a42=0
a43=0
a44=0
move=1
oldBoard=""
newBoard=""
targetPoint=64

PrintBoard()
{
  GetCubeVar $1
  oldBoard=$(echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44")
  var11="     "
  var12="     "
  var13="     "
  var14="     "
  var21="     "
  var22="     "
  var23="     "
  var24="     "
  var31="     "
  var32="     "
  var33="     "
  var34="     "
  var41="     "
  var42="     "
  var43="     "
  var44="     "
  for i in 1 2 3 4;do
    {
      for j in 1 2 3 4;do
      {
        eval pos=\$a$i$j
        if [ $pos -ne 0 ];then
        {
           case ${#pos} in
             1)
               eval var$i$j="\ \ "$pos"\ \ ";;
             2)
               eval var$i$j="\ \ "$pos"\ ";;
             3)
               eval var$i$j="\ "$pos"\ ";;
             *)
               eval var$i$j="\ "$pos;;
          esac
        }
        fi
      }
      done
    }
    done  

  dialog --infobox " \
-------------------------\n \
|     |     |     |     |\n \
|$var11|$var12|$var13|$var14|\n \
|     |     |     |     |\n \
-------------------------\n \
|     |     |     |     |\n \
|$var21|$var22|$var23|$var24|\n \
|     |     |     |     |\n \
-------------------------\n \
|     |     |     |     |\n \
|$var31|$var32|$var33|$var34|\n \
|     |     |     |     |\n \
-------------------------\n \
|     |     |     |     |\n \
|$var41|$var42|$var43|$var44|\n \
|     |     |     |     |\n \
-------------------------\n" 20 50
}

GetCubeVar()
{
  a11=$(awk -F "," '{print $1}' $1)
  a12=$(awk -F "," '{print $2}' $1)
  a13=$(awk -F "," '{print $3}' $1)
  a14=$(awk -F "," '{print $4}' $1)
  a21=$(awk -F "," '{print $5}' $1)
  a22=$(awk -F "," '{print $6}' $1)
  a23=$(awk -F "," '{print $7}' $1)
  a24=$(awk -F "," '{print $8}' $1)
  a31=$(awk -F "," '{print $9}' $1)
  a32=$(awk -F "," '{print $10}' $1)
  a33=$(awk -F "," '{print $11}' $1)
  a34=$(awk -F "," '{print $12}' $1)
  a41=$(awk -F "," '{print $13}' $1)
  a42=$(awk -F "," '{print $14}' $1)
  a43=$(awk -F "," '{print $15}' $1)
  a44=$(awk -F "," '{print $16}' $1)
}

SetRandom()
{
  if [ $move -eq 1 ];then
  {
    return
  }
  fi
  
  rand=$(od -An -N1 -tu1 < /dev/urandom)
  rand=$(($rand%16+1))
  
  while [ $rand -gt 0 ];do
  {
    for i in 1 2 3 4;do
    {
      for j in 1 2 3 4;do
      {
        eval pos=\$a$i$j
        if [ $pos -eq 0 ];then
        {
          rand=$(($rand-1))
          if [ $rand -eq 0 ];then
          {
            num=$(od -An -N1 -tu1 < /dev/urandom)
            num=$(($num%3+1))
            if [ $num -eq 3 ];then
            {
              eval a$i$j=8
            }
            else
            {
              eval a$i$j=$(($num*2))
            }
            fi
            move=1
          }
          fi
        }
        fi
      }
      done
    }
    done
  }
  done
}

MoveLeft()
{
  for i in 1 2 3 4;do
  {
    c=1
    flag=0
    while [ $c -lt 4 ];do
    {
      eval check=\$a$i$c
      if [ $check -eq 0 ];then
      {
        flag=$(($flag+1))
        k=$c
        while [ $k -lt 4 ];do
        {
          eval a$i$k=\$a$i$(( $k + 1 ))
          k=$(( $k + 1 ))
        }
        done
        eval a$i$k=0
      }
      fi
      eval check=\$a$i$c
      if [ $check -ne 0 -o $flag -ge 3 ];then
      {
        c=$(($c+1))
      }
      fi
    }
    done
    
    for j in 1 2 3;do
    {
      eval curcube=\$a$i$j
      eval nextcube=\$a$i$(($j+1))
      
      if [ $curcube -eq $nextcube ];then
      {
        eval a$i$j=$(($curcube + $nextcube))
        if [ $(($curcube+$nextcube)) -eq $targetPoint ];then
        {
           Win
        }
        fi
        k=$(( $j + 1 ))
        while [ $k -lt 4 ];do
        {
          eval a$i$k=\$a$i$(( $k + 1 ))
          k=$(( $k + 1 ))
        }
        done
        eval a$i$k=0
      }
      fi
    }
    done
  }
  done
  
  newBoard="$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44"
  if [ "$newBoard" != "$oldBoard" ];then
  {
    move=0
  }
  fi
  SetRandom  
  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44">.game.tmp
}

MoveRight()
{
  for i in 1 2 3 4;do
  {
    c=4
    flag=0
    while [ $c -gt 1 ];do
    {
      eval check=\$a$i$c
      if [ $check -eq 0 ];then
      {
        flag=$(($flag+1))
        k=$c
        while [ $k -gt 1 ];do
        {
          eval a$i$k=\$a$i$(( $k - 1 ))
          k=$(( $k - 1 ))
        }
        done
        eval a$i$k=0
      }
      fi
      eval check=\$a$i$c
      if [ $check -ne 0 -o $flag -ge 3 ];then
      {
        c=$(($c-1))
      }
      fi
    }
    done

    for j in 4 3 2;do
    {
      eval curcube=\$a$i$j
      n=$(( $j - 1 ))
      eval nextcube=\$a$i$n

      if [ $curcube -eq $nextcube ];then
      {
        if [ $(($curcube+$nextcube)) -eq $targetPoint ];then
        {
           Win
        }
        fi
        eval a$i$j=$(($curcube + $nextcube))
        k=$(( $j - 1 ))
        while [ $k -gt 1 ];do
        {
          eval a$i$k=\$a$i$(( $k - 1 ))
          k=$(( $k - 1 ))
        }
        done
        eval a$i$k=0
      }
      fi
    }
    done
  }
  done
  
  newBoard="$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44"
  if [ "$newBoard" != "$oldBoard" ];then
  {
    move=0
  }
  fi
  SetRandom
  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44">.game.tmp 
}

MoveUp()
{
  for j in 1 2 3 4;do
  {
    c=1
    flag=0
    while [ $c -lt 4 ];do
    {
      eval check=\$a$c$j
      if [ $check -eq 0 ];then
      {
        flag=$(($flag+1))
        k=$c
        while [ $k -lt 4 ];do
        {
          eval a$k$j=\$a$(($k+1))$j
          k=$(( $k + 1 ))
        }
        done
        eval a$k$j=0
      }
      fi
      eval check=\$a$c$j
      if [ $check -ne 0 -o $flag -ge 3 ];then
      {
        c=$(($c+1))
      }
      fi
    }
    done

    for i in 1 2 3;do
    {
      eval curcube=\$a$i$j
      n=$(( $i + 1 ))
      eval nextcube=\$a$n$j

      if [ $curcube -eq $nextcube ];then
      {
        if [ $(($curcube+$nextcube)) -eq $targetPoint ];then
        {
           Win
        }
        fi
        eval a$i$j=$(($curcube + $nextcube))
        k=$(( $i + 1 ))
        while [ $k -lt 4 ];do
        {
          eval a$k$j=\$a$(( $k + 1 ))$j
          k=$(( $k + 1 ))
        }
        done
        eval a$k$j=0
      }
      fi
    }
    done
  }
  done

  newBoard="$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44"
  if [ "$newBoard" != "$oldBoard" ];then
  {
    move=0
  }
  fi
  SetRandom
  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44">.game.tmp
}

MoveDown()
{
  for j in 1 2 3 4;do
  {
    c=4
    flag=0
    while [ $c -gt 1 ];do
    {
      eval check=\$a$c$j
      if [ $check -eq 0 ];then
      {
        flag=$(($flag+1))
        k=$c
        while [ $k -gt 1 ];do
        {
          eval a$k$j=$\a$(( $k - 1 ))$j
          k=$(( $k - 1 ))
        }
        done
        eval a$k$j=0
      }
      fi
      eval check=\$a$c$j
      if [ $check -ne 0 -o $flag -ge 3 ];then
      {
        c=$(($c-1))
      }
      fi
    }
    done

    for i in 4 3 2;do
    {
      eval curcube=\$a$i$j
      n=$(( $i - 1 ))
      eval nextcube=\$a$n$j

      if [ $curcube -eq $nextcube ];then
      {
        if [ $(($curcube+$nextcube)) -eq $targetPoint ];then
        {
           Win
        }
        fi
        eval a$i$j=$(($curcube + $nextcube))
        k=$(( $i - 1 ))
        while [ $k -gt 1 ];do
        {
          eval a$k$j=\$a$(( $k - 1 ))$j
          k=$(( $k - 1 ))
        }
        done
        eval a$k$j=0
      }
      fi
    }
    done
  }
  done

  newBoard="$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44"
  if [ "$newBoard" != "$oldBoard" ];then
  {
    move=0
  }
  fi
  SetRandom
  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44">.game.tmp  
}

KeyBoardHandler()
{
  while [ True ]; do
  {
    key=`stty -echo -icanon; dd bs=1 count=1 2>/dev/null`
    if [ $key = "a" ]; then
    {
      MoveLeft
      PrintBoard .game.tmp
    }
    elif [ $key = "s" ]; then
    {
      MoveDown
      PrintBoard .game.tmp
    }
    elif [ $key = "d" ]; then
    {
      MoveRight
      PrintBoard .game.tmp
    }
    elif [ $key = "w" ]; then
    {
      MoveUp
      PrintBoard .game.tmp
    }
    elif [ $key = "q" ]; then
    {
       return
    }
    fi
  }
  done
}

New()
{
  if test -e '.game.tmp' ; then
  {
    rm -f .game.tmp
  }
  fi 

a11=0
a12=0
a13=0
a14=0
a21=0
a22=0
a23=0
a24=0
a31=0
a32=0
a33=0
a34=0
a41=0
a42=0
a43=0
a44=0
  
  move=0
  SetRandom
  move=0
  SetRandom
  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44">.game.tmp
  PrintBoard .game.tmp
  KeyBoardHandler 
}

Resume()
{
  if  test -e '.game.tmp' ; then
  {
    PrintBoard .game.tmp
  }
  fi
  KeyBoardHandler
}

Load()
{ 
  dialog --msgbox "Your game progress have been loaded." 20 80
  if test -e '.game.save' ; then
  {
    PrintBoard .game.save
  }
  fi
  KeyBoardHandler
}

Save()
{
  dialog --msgbox 'Your game progress have been saved.' 20 80
  if test -e '.game.save' ; then
  {
    rm .game.save
  }
  fi

  echo "$a11,$a12,$a13,$a14,$a21,$a22,$a23,$a24,$a31,$a32,$a33,$a34,$a41,$a42,$a43,$a44" > .game.save
}

Quit()
{
  if test -e '.game.tmp' ; then
  {
    rm .game.tmp
  }
  fi
  exit
}

Win()
{
  dialog --exit-label "You Win!!" --textbox congratulations 20 80
  exit
}

ShowMenu()
{
  while [ True ]; do
  {
    menuChoice=$(dialog --title "menu" --menu "command line 2048" 20 50 5 \
    N "New Game - Start a new 2048 game" \
    R "Resume - Resume previous Game" \
    L "Load - Load from previous save game" \
    S "Save - Save current game state" \
    Q "Quit" 3>&1 1>&2 2>&3 3>&-)

    if test $? -eq 1;then
    {
      exit
    }
    fi
    
    case $menuChoice in
      N)
        New;;
      R)
        Resume;;
      L)
        Load;;
      S)
        Save;;
      Q)
        Quit;;
      *)
        ;;
    esac
  }
done
}
###################################Code Flow#################################
dialog --exit-label "Play A Game" --textbox welcome 20 50
ShowMenu
