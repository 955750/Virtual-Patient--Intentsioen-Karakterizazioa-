# "Chatbot"-a frogatzeko argibideak

![](https://www.linkedin.com/pulse/connecting-rasa-whatsapp-messenger-tharun-reddy-mamillapally-)

##  1. Beharrezko Erreminten Instalazioa

"Chatbot"-arekin lan egiteko PyCharm IDE-a instalatzea gomendatzen dut eta horrekin batera Python 3.7 edo 3.8 
bertsioa. Izan ere, Python bertsio berrienek bategarritasun arazoak eman ditzakete.

##  2. Lanean Hasteko Beharrezkoa

Behin PyCharm eta Python instalatuta, "VPChatbot" proiektua irekiko dugu eta PyCharm-eko "Terminal" ataleko
kontsolan honako agindua sartuko dugu: 

`$ pip install rasa ` 

Agindu honen bitartez RASArekin lan egiteko beharrezko paketeen instalazioa osatuko da (honek 5 minutu inguru iraun
ditzake).

##  3. "Chatbot"-a frogatu

"Chatbot"-arekin solasaldi bat izateko aurretik sailkatzaile bat entrenatzea beharrezkoa da guk sartutako
informazioarekin. Horretarako honako agindua sartuko da "Terminal" agindu kontsolan:

`$ rasa train ` 

Behin sailkatzailea entrenatuta, "chatbot"-arekin solasaldi bat izatea besterik ez zaigu falta. Horretarako honako
agindua sartuko da:

`$ rasa shell ` 

Amaitzeko, elkarrizketa eten nahi bada, "/stop" idatziko da kontsolan.
