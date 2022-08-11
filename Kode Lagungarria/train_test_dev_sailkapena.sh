#!/bin/bash

## Esaldi jakin bat zein katalogotan dagoen bilatzeko funtzioa
function esaldia_katalogoan_bilatu(){
# |--> 1. Parametroa: katalogoa = train | test | dev
# |--> 2. Parametroa: bilatu nahi den esaldia (ADBZ. MTF0001 +++ bonjour. donc. pourquoi venez-vous aux urgences?)

  elkarrizketak=$(ls ../Korpusak/LabForSims/datu_sortak/$1) # katalogoko elkarrizketak eskuratu ($1 = train | test | dev)
  katLuzera=$(echo $elkarrizketak | wc -w) # katalogoko elkarrizketa kopurua (train --> 29 | test --> 6 | dev --> 6)
  echo ""
  echo "Elkarrizketak ("$1"): "$elkarrizketak
  echo "Elkarrizketa kopurua("$1"): "$katLuzera
  echo ""
  aurkitua=1 # true = 0; false = 1
  kont=1 # katalogoa iteratzeko aldagaia (1-29) | (1-6) | (1-6)

  # esaldia bilatu aurkitu arte edo $1 katalogo osoa zeharkatu arte
  while [ $aurkitua == 1 -a $kont -le $katLuzera ]
  do
    # elkarrizketa oso bat eskuratu (ADBZ. ../Korpusak/LabForSims/datu_sortak/train/Interne01/dialogues"
    unekoElkarrizketa=$(echo $elkarrizketak | cut -d' ' -f $kont) # elkarrizketaren izena eskuratu (ADBZ. Interne01)
    elkPathErlOsoa="../Korpusak/LabForSims/datu_sortak/"$1"/$unekoElkarrizketa/dialogues" 
    echo "Elkarrizketaren helbidea: "$elkPathErlOsoa

    # $2 parametroa moldatu bilatu nahi den parametroa soilik lortzeko (ADBZ. bonjour. donc. pourquoi venez-vous aux urgences?)
    esaldia=$2
    esaldiaSubstring=${esaldia:12}

    # esaldiaren amaieran dagoen "?" ikurra kentzeko, egotekotan (ARAZOAK EMATEN DITU) 
    # (ADBZ. bonjour. donc. pourquoi venez-vous aux urgences)
    galderaIkurKop=$(echo $esaldiaSubstring | grep -o "?" | wc -l)
    if [ $galderaIkurKop -ne 0 ]
    then
      esaldiaSubstring=$(echo $esaldiaSubstring | sed 's/\s*?\s*//'$galderaIkurKop'g')
    fi
    echo "substring: \"$esaldiaSubstring\""

    # esaldia egungo elkarrizketan dagoen begiratu (ADBZ. d03000000 Bonjour. Donc. Pourquoi venez-vous aux Urgences ? )
    esaldiaAurkituta=$(grep -i "$esaldiaSubstring" $elkPathErlOsoa)
    #echo "hami: "$elkPathErlOsoa
    #grep -i "$esaldiaSubstring" ../Korpusak/LabForSims/datu_sortak\ \(train_dev_test\)/dev/Interne03/dialogues
    echo "esaldia: "$esaldiaAurkituta
    echo "AGINDUA: grep -i \"$esaldiaSubstring\" $elkPathErlOsoa"

    # a katea hutsa bada, hau da, esaldia aurkitu EZ bada --> kontagailua eguneratu
    if [ -z "$esaldiaAurkituta" ]
    then
      echo "kontagailua: "$kont
      echo -e "esaldia EZ da aurkitu \n"
      kont=`expr $kont + 1`

    # esaldia aurkitu bada --> esaldia non aurkitu den adierazi "emaitza.txt" fitxategian
    else
      echo -e "esaldia AURKITU DA \n"
      echo $1" ($unekoElkarrizketa) --> "$esaldia >> ../Korpusak/LabForSims/emaitza.txt
      aurkitua=0
    fi
  done
  return $aurkitua
}


#### Esaldiak zein multzotan (train, test eta dev) dauden adierazten duen programa ####

# |--> AGINDU ADBZ.: ./kodeketa_aldatu.sh ../Korpusak/Campillos/dialogues/latin1 ../Korpusak/Campillos/dialogues/utf-8
#echo "aurkitua: "$?
#  esaldi bakoitza irakurri "sailkatutakoEsaldiak.txt" fitxategitik
while read esaldia
do
  echo "esaldia: "$esaldia
  aurkitua=1 # true = 0; false = 1

  # esaldia "train" katalogoan dagoen begiratu
  kat="train"
  esaldia_katalogoan_bilatu train "$esaldia"
  aurkitua=$?

  # esaldia aurkitu EZ bada --> "test" katalogoan bilatu
  if [ $aurkitua -eq 1 ]
  then
    kat="test"
    esaldia_katalogoan_bilatu test "$esaldia"
    aurkitua=$?

    # esaldia aurkitu EZ bada --> "dev" katalogoan bilatu
    if [ $aurkitua -eq 1 ]
    then
      kat="dev"
      esaldia_katalogoan_bilatu dev "$esaldia"
      aurkitua=$?
    fi
  fi

  # emaitza eskuratu eta "emaitza.txt" fitxategian adierazi
  if [ $aurkitua -eq 1 ]
  then
    echo "aurkitua: "$aurkitua "(FALSE); katalogoa: - "
    echo "EZ DA AURKITU --> "$esaldia >> ../Korpusak/LabForSims/emaitza.txt
  else
    echo "aurkitua: "$aurkitua "(TRUE); katalogoa: $kat"
  fi
done < ../Korpusak/LabForSims/sailkatutakoEsaldiak.txt
