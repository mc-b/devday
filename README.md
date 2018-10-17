Beispiele: [Digicomp DevDay 2018](https://www.digicomp.ch/events/development-events/devday-2018)
=============================================================================================

### Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [Vagrant](https://www.vagrantup.com/) und [VirtualBox](https://www.virtualbox.org/).

Projekt [lernkube](https://github.com/mc-b/lernkube), auf der Git/Bash Kommandozeile (CLI), klonen, Konfigurationsdatei (.yaml) kopieren und Installation starten. 

	git clone https://github.com/mc-b/lernkube
	cd lernkube
	cp templates/DevDay.yaml config.yaml
	vagrant plugin install vagrant-disksize
	vagrant up


Nach der Installation: öffnet die Interaktive Lernumgebung mit dem Machine Learning Beispiel [http://localhost:32088/notebooks/02-2-MLTempHumSensor.ipynb](http://localhost:32088/notebooks/02-2-MLTempHumSensor.ipynb) und spielt das Beispiel, mittels `Run` durch.

### Aufbau einer Internet of Things – Machine Learning Fast Data Pipeline mit Docker/Kubernetes

#### Folie 10 - IoT Gerät Programmieren

* IoTKit V3 via USB anschliessen, neues Laufwerk (Mountpoint) wird angezeigt
* mbed.htm Doppelklicken, [os.mbed.com](http://os.mbed.com) Website wird anzeigt
* Wechsel auf [MQTTPublish Repository](https://os.mbed.com/teams/IoTKitV3/code/MQTTPublish/) und `Import into Compiler` drücken
* mbed Compiler wird gestartet und Programm [MQTTPublish] in Compiler Umgebung importiert
* Evtl. WLAN (SSID/PW) Daten in `mbed_app.json` und ggf. `host` und `port` in `main.cpp` anpassen
* Programm mittels `Compile` Übersetzen in Maschinensprache und `MQTTPublish.bin`-Datei auf Laufwerk `DAPLINK` speichern und `Reset` Button auf IoTKit V3 drücken
* Das IoTKit V3 sendet Temperatur und Luftfeuchtigkeitsdaten an einen MQTT Broker
* Umgebung mit Installierter `mosquitto-clients` Tools starten, z.B. `Bash`
* MQTT Daten mittels `mosquitto_sub -t 'iotkit/#' -h iot.eclipse.org` anzeigen lassen.

#### Folie 15 - ML/IoT (02-2-MLTempHumSensor)

* Jupyter Notebook, mit Machine Learning / IoT Beispiel mittels [http://localhost:32088/notebooks/02-2-MLTempHumSensor.ipynb](http://localhost:32088/notebooks/02-2-MLTempHumSensor.ipynb) aufrufen und durcharbeiten mit `Run`.

#### Folie 21 - Docker und Kubernetes

OS Ticket, als ein Beispiel für die Ausbildung an Berufschulen zeigen.

	kubectl apply -f duk/osticket
	startsrv osticket
	kubectl delete -f duk/osticket

Hinweis auf [lernkube](https://github.com/mc-b/lernkube).

#### Folie 29 - Fast Data Pipeline

Edge und Data Center: starten Mosquitto, Kafka, MQTT-Bridge, Streams und Consumer Beispiel

	kubectl apply -f devdays/iotmldata/
	
Weitere Möglichkeiten und Sourcecode auf https://github.com/mc-b/duk/tree/master/kafka#kafka-mit-mqtt-bridge und https://github.com/mc-b/iot.kafka.git.

Kontrollieren im Dashboard Logs der Pods iot-kafka-* anschauen, mittels Weave oder 

	logs iot-kafka-consumer
	logs iot-kafka-pipe
	
Weave Oberfläche mittels `weave` in Bash starten und Verbindungen zeigen.

#### Folie 30 - IoT und Prozesse

Camunda BPMN Workflow Engine starten

	kubectl apply -f misegr/bpmn/camunda.yaml
	
Camunda BPMN Oberfläche (Tasklist) aufrufen [https://localhost:30443/camunda](https://localhost:30443/camunda), Anmelden mit `demo/demo`. Es sollten nur zwei Task offen sein.

BPMN Prozess veröffentlichen 	

	cd misegr/bpmn/
	curl -k -w "\n" \
	-H "Accept: application/json" \
	-F "deployment-name=rechnung" \
	-F "enable-duplicate-filtering=true" \
	-F "deploy-changed-only=true" \
	-F "Rechnung.bpmn=@RechnungStep3.bpmn" \
	https://localhost:30443/engine-rest/deployment/create

Magnet an Hallsensor auf IoTKit anlegen und warten bis `alert` auf Display erscheint und LED 13 leuchtet.

Wechsel in BPMN Oberfläche (Tasklist). Es sollte eine neue Task erstellt worden sein.

