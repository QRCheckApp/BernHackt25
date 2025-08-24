BärnHäckt 2025 — „GspänliPlänli“ von „Team Tübingen“
====================================================

**Challenge** „Die perfekte Einkaufsliste – ohne Streit, ohne Spam, mit System“

Gspänli steht für Kumpel, Plänli steht für Plan — Mit unserer App wird die Essensplanung mit Freunden im Urlaub ganz einfach.

[Zum Source-Code auf GitHub](https://github.com/QRCheckApp/BernHackt25) (Die native App ist im Unterordner „flutter-app“, das Backend in „laravel-app“)

[Zum 1 min Video-Pitch auf YouTube](https://www.youtube.com/watch?v=AAYLAVFmRfs)

## Die Idee

Stell dir vor, du gehst mit deinen Freunden für ein Wochenende auf eine Skitour in eine abgelegene Hütte. Kein Supermarkt weit und breit. Aber wie entscheidet ihr, was es zu essen gibt – und wie stellt ihr sicher, dass nichts vergessen wird?

Ohne die App kann die Essensplanung schnell mühsam werden — Wer ist Vegetarier? Wer verträgt keine Laktose? Wer mag was? Genau hier kommt *GspänliPlänli* ins Spiel. Innerhalb weniger Sekunden kann jeder seine Lieblingsgerichte vorschlagen. Aus ein paar Stichwörtern erzeugt die KI passende Vorschläge – und berücksichtigt dabei automatisch die Vorlieben, Unverträglichkeiten und Ernährungsweisen aller Mitreisenden.
Danach können die Nutzer alle Vorschläge „swipen“, einzelne Gerichte ablehnen oder sogar „super-liken“. *GspänliPlänli* erstellt daraus automatisch den perfekten Essensplan für die Hütte.

Einen Plan zu haben ist das eine – aber wie geht man nun gemeinsam einkaufen, ohne chaotische Excel-Tabellen und ohne doch noch etwas zu vergessen? Und muss wirklich Pfeffer gekauft werden, wenn ohnehin jeder genug davon zuhause hat? Genau hier setzt die *Einkaufs-Phase* der App an. Eine komplette Zutatenliste wird automatisch erstellt. Dann kann jeder markieren, was er einkaufen möchte – oder was bereits vorhanden ist. So kommt die Gruppe spielend leicht an alles Nötige, ohne dass jemand die Koordination übernehmen muss.

Weiterführende Ideen haben wir erstmal weggelassen, darunter z.B. das Scannen des Kühlschranks mit KI um automatisiert alle vorhandenen Lebensmittel auf der Einkaufsliste abzuhaken. Oder auch eine Abrechnungsfunktion, mit der man die ganzen Einkäufe direkt in der App abrechnen kann, sowie eine Funktion zum Schätzen von Mengenangaben.


## Tech-Info

Wir haben bereits einen voll funktionsfähigen Prototypen, der die Hauptfunktionen der App demonstriert — die *Gerichteauswahl-Phase* und die *Einkaufs-Phase*. Auch einige weitere Funktionen, wie die Startseite der App und das Bearbeiten des eigenen Profils sind schon nutzbar. Die übrigen Teile des Konzepts und Erweiterungen lassen sich später problemlos ergänzen.

### Userflow
Dieser Userflow konkretisiert [obige Idee](#die-idee) und ist die Basis für unseren Prototyp und eine weitere Implementierung.

##### Hauptfunktionalität
![Hauptfunktionalität Userflow](/documentation-assets/Main-Flow.png)

##### Account-Funktionalität
![Account-Funktionalität Userflow](/documentation-assets/Account-Flow.png)

### Architektur
Da wir die App gerne selbst benutzen würden, war unser Ziel nicht bloß eine hübsche Mockup-Demo zu bauen, sondern einen wirklich **funktionsfähigen Prototypen**, den man direkt benutzen und später weiterentwickeln kann. Dabei war uns außerdem wichtig, dass die App nicht einfach alles blind mit KI löst, sondern dass ein **gut durchdachter Prozess** das Herzstück bildet: ein Userflow, der die Essensplanung in der Gruppe ganz natürlich abbildet.

Die **KI** kommt genau dort zum Einsatz, wo sie echten Mehrwert bietet — bei der **Generierung von Gerichten**. Hier spart sie den Nutzern das mühsame manuelle Anlegen von Rezeptvorschlägen und berücksichtigt automatisch alle Präferenzen, Unverträglichkeiten und Ernährungsweisen der Gruppe.

![Architektur](/documentation-assets/Architecture.svg)
- Mit **Laravel und MariaDB** setzen wir auf ein stabiles, modernes Backend, in dem wir als Team bereits Erfahrung gesammelt haben.
- Mit **Flutter** sind wir bereits vertraut. Für unser Ziel eines funktionsfähigen Prototyps, der sich auf Android und iOS nativ anfühlt und sich später problemlos zu einer vollwertigen App ausbauen lässt, ist Flutter die optimale Wahl.
- Besonders spannend finden wir, wie bei unserer Lösung **generative KI** und ein **durchdachter Userflow mit intuitiver UI** ineinandergreifen. Das Ergebnis ist eine **All-in-One-Lösung**, die Essensplanung im Urlaub oder auf Ausflügen nicht nur erleichtert, sondern komplett stressfrei macht.


---------------------
![Bär](documentation-assets/bernhackt.webp)
