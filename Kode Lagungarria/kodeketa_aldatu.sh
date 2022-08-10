#!/bin/bash

## Errore mezua pantailaratzen duen funtzioa
function errore_mezua(){
  echo ""
  echo "#####################"
  echo "#		    #"
  echo "#     ERROREA!!     #" 
  echo "#		    #"
  echo "#####################"
  echo ""
  echo "Aginduak honako egitura izan behar du:"
  echo "./kodeketa_aldatu_eskalagarria.sh jatorriKatalogoa helburuKatalogoa"
  echo "OHARRA: **helburuKatalogoa ez badago sortuta automatikoki sortuko da**"
  echo ""
}

#### Kodeketa aldaketa burutzeko programa ####
# |--> 1. Parametroa: Jatorri katalogoa
# |--> 2. Parametroa: Helburu katalogoa (sortuta ez badago AUTOMATIKOKI sortuko da)

# |--> AGINDU ADBZ.: ./kodeketa_aldatu.sh ../Korpusak/Campillos/dialogues/latin1 ../Korpusak/Campillos/dialogues/utf-8


# aginduak 2 parametro baditu
if [ $# -eq 2 ]
then

  # jatorriKatalogoa existitzen EZ bada --> ERROREA
  if ! test -e $1
  then
    echo "ERROREA!!"
    echo "jatorriKatalogoa ez da existitzen"
    errore_mezua

  # jatorriKatalogoa katalogo bat EZ bada --> ERROREA
  elif ! test -d $1
  then
    echo "ERROREA!!"
    echo "jatorriKatalogoa ez da katalogo bat"
    errore_mezua

  # aginduak beharrezko ezaugarriak betetzen ditu
  else
    echo ""
    echo "ARAZORIK EZ!!"
    echo ""
    jatorriFitxGuztiak=$(ls $1) # fitxategi guztiak eskuratu
    for jf in $jatorriFitxGuztiak
    do
      jfHelbidea=$1$jf # jatorri fitxategien helbide erlatiboa osatu (ADBZ. latin1/20170217-111805.lex")

      # azken karakterea jatorriKatalogoan / den begiratu eta ez bada gehitu
      jatorriKatalogoa=$1
      jkAzkenKat=${jatorriKatalogoa: -1}
      if [ $jkAzkenKat != "/" ]
      then
        jfHelbidea=$1"/"$jf
      fi

      jfTxt="$(echo $jf | cut -d'.' -f 1).txt" # fitxategia .txt bihurtu (ADBZ. 20170217-111805.txt)
      hfHelbidea=$2$jfTxt # helburu fitxategien helbide erlatiboa osatu (ADBZ. utf8/20170217-111805.txt")

      # azken karakterea helburuKatalogoan / den begiratu eta ez bada gehitu
      helburuKatalogoa=$2
      hkAzkenKat=${helburuKatalogoa: -1}
      if [ $hkAzkenKat != "/" ]
      then
        hfHelbidea=$2"/"$jfTxt
      fi

      jfKodeketaLuzea=$(file -bi $jfHelbidea) #jatorrizko fitxategiaren kodeketa eskuratu (ADBZ. text/plain; charset=utf-8)
      jfKodeketa=$(echo $jfKodeketaLuzea | cut -d'=' -f 2) #jfKodeketaLuzea aldagaitik kodeketa soilik lortu (ADBZ. utf-8)

      #helburuKatalogoa existitzen ez bada, sortu egingo da
      if ! test -e $2
      then
        mkdir $2
      fi

      echo "Sarrera fitxategia: "$jfHelbidea
      echo "Kodeketa: "$jfKodeketa
      echo "Irteera fitxategia: "$hfHelbidea
      echo ""
      iconv -f $jfKodeketa -t utf-8 -o $hfHelbidea $jfHelbidea #fitxategien kodeketa utf-8 bihurtu
    done
  fi

# aginduak parametro kopuru desegokia du
else
  errore_mezua
fi
