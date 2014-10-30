beacons
=======

iOS App that uses iBeacons to assist students

#Introductie

Beacons is een app die studenten en studentenassistenten het leren op verschillende locaties binnen de UvA makkelijker maakt. De app houdt door te scannen naar iBeacons in het gebouw bij waar iedereen zich bevindt en stuurt deze informatie door naar een server die voor de overige gebruikers toegankelijk is. Ook is het mogelijk om om hulp te vragen via de app of te kijken waar de assistenten zich op dit moment bevinden.


#Features:

De app staat in verbinding met een "Parse.com" database. In deze database staan de beschrijvingen en locaties van de beacons die aanwezig zijn in het gebouw.

De app zal eenmalig de gegevens van alle beacons ophalen en deze opslaan in NSUserDefaults.

De app scant nu naar elke iBeacon in de lijst om te kijken of deze binnen bereik is en stelt een lijst op met elke beacon die in het bereik van het apparaat is (de beacon die zich het dichtst bij bevind zal bovenaan komen te staan).

Indien er beacons gevonden zijn zal de app zijn lijst doorsturen naar de parse server, hierbij zal de record met zijn vorige gegevens overschreven worden met de nieuwe gegevens (naam, id, dichtstbijzijnde beacon).

In de app is een “Help” button aanwezig, indien deze ingedrukt wordt zal er een bericht naar de server verstuurd worden waarmee om hulp wordt gevraagd. Deze vraag zal via een push bericht doorgestuurd worden naar de assistenten. Ook kan er in de app gezien worden waar alle assistenten zich bevinden zodat de studenten deze kunnen opzoeken.


##Assistenten:
Voor assistenten zijn extra opties aanwezig, waaronder:
Studentoverzicht: een lijst met alle studenten die aanwezig zijn en de beacon die het dichtst bij de student is. Ook is hier de tijd te vinden waarop de studenten het gebouw binnen zijn gekomen.

Vragenoverzicht: een overzicht met alle vragen gesteld door studenten, waarbij de vragen die behandeld zijn afgestreept kunnen worden zodat makkelijk bij te houden is welke vragen nog niet behandeld zijn maar ook een overzicht is te vinden van alle vragen die gesteld zijn door de studenten.
