## Beharrezko liburutegiak
import os # katalogoak sortzeko ("os.makedirs" funtzioa erabilita)
import random as r # ausazko zenbakiak eskuratzeko ("r.sample" funtzioa erabilita)
import shutil # katalogoak leku batetik bestera kopiatzeko ("shutil.copytree" funtzioa erabilita)


## Aldagai globalak
#elkarrizketa_izenak = os.listdir("dialogues") #Fitxategian izenak gorde: [Interne01, Interne02, ..., Interne40, Interne41]
elkarrizketa_izenak = os.listdir(r'..\Korpusak\LabForSims\dialogues') #Fitxategian izenak gorde: [Interne01, Interne02, ..., Interne40, Interne41]
print("Elkarrizketa izenak: " + str(elkarrizketa_izenak))
print("Luzera: " + str(len(elkarrizketa_izenak)))
print("")


#### Elkarrizketa guztien datu-sortatik abiatuta tamaina jakin bateko azpimultzo bat sortzeko programa ####
# |--> 1. Parametroa: Multzo osoaren zenbateko ehunekoa hartuko duen
# |--> 2. Parametroa: Multzo berriak hartuko duen izena

def datu_sorta_osatu(multzo_ehunekoa, multzo_izena):

    # [0 - elkarrizketa kop.) tarteko zenbaki zerrenda bat lortu, ehunekoarekin bat datorrena
    # (ADBZ (0.7, "train"). [0, 1, 4, 5, 7, 9, 11, 12, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 26, 27, 29, 30, 31, 32, 33, 36, 37, 38, 39]
    # (ADBZ (0.15, "test"). [8, 13, 25, 34, 35, 40]
    # (ADBZ (0.15, "dev"). [2, 3, 6, 10, 20, 28]
    multzo_ind = r.sample(range(0, len(elkarrizketa_izenak)), round(41 * multzo_ehunekoa))
    multzo_ind.sort(reverse = True)
    print("multzo_ind: " + str(multzo_ind))
    print("luzera: " + str(len(multzo_ind)))

    # multzo_izena izeneko katalogoa sortu eta elkarrizketen kopiaketarako jatorria eta helburua zehaztu
    os.makedirs(f"datu_sortak/{multzo_izena}", exist_ok = True)
    source = r'..\Korpusak\LabForSims\dialogues'
    destination = fr'..\Korpusak\LabForSims\datu_sortak\{multzo_izena}'

    # zenbaki zerrendako indize bakoitzari dagokion elkarrizketa jatorritik helburura kopiatu
    for elk_ind in multzo_ind:
        print(elk_ind)
        print(elkarrizketa_izenak[elk_ind])
        elk_izena = elkarrizketa_izenak[elk_ind]
        shutil.copytree(f"{source}/{elk_izena}", f"{destination}/{elk_izena}", dirs_exist_ok = True)

    # kopiatu diren elkarrizketak elkarrizketa guztien aldagaitik ezabatu bi multzo desberdinetan
    # elkarrizketak EZ errepikatzeko
    for elk_ind in multzo_ind:
        elkarrizketa_izenak.pop(elk_ind)
    print(elkarrizketa_izenak)


#### Elkarrizketen datu-sorta "train"(%70), "test"(%15), "dev"(%15) multzoetan banatzeko programa ####
datu_sorta_osatu(0.7, "train")
datu_sorta_osatu(0.15, "test")
datu_sorta_osatu(0.15, "dev")
