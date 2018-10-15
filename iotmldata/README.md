Apache Kafka®
-------------

Apache Kafka® ist eine verteilte Streaming-Plattform.

Eine Streaming-Plattform hat drei Schlüsselfunktionen:

* Veröffentlichen und abonnieren Sie Streams von Datensätzen, ähnlich einer Nachrichtenwarteschlange oder eines Enterprise-Messaging-Systems.
* Speichern Sie Streams von Datensätzen auf eine fehlertolerante, dauerhafte Weise.
* Verarbeiten von Datenströmen, wenn sie auftreten.

Kafka wird im Allgemeinen für zwei große Klassen von Anwendungen verwendet:

* Erstellen von Echtzeit-Streaming-Datenpipelines, die zuverlässig Daten zwischen Systemen oder Anwendungen erhalten
* Erstellen von Echtzeit-Streaming-Anwendungen, die die Datenströme transformieren oder darauf reagieren

### Standard Kafka Umgebung

**Starten**

	kubectl create -f devdays/iotmldata/kafka.yaml
	kubectl create -f devdays/iotmldata/zookeeper.yaml
	
**Topics erstellen**

Terminal starten

	runbash kafka

Im Terminal
	
	kafka-topics --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic streams-plaintext-input	
	kafka-topics --list --zookeeper zookeeper:2181

**Daten schreiben und lesen**

In jeweils einem eigenen Terminal

schreiben

	kafka-console-producer --broker-list kafka:9092 --topic streams-plaintext-input

lesen

	kafka-console-consumer --bootstrap-server kafka:9092 \
	    --topic streams-plaintext-input \
	    --from-beginning \
	    --formatter kafka.tools.DefaultMessageFormatter \
	    --property print.value=true 

### Kafka mit MQTT Bridge

**Starten**

	kubectl create -f devdays/iotmldata/mosquitto.yaml
	kubectl create -f devdays/iotmldata/mqtt-kafka-bridge.yaml

**Testen**

Im kafka Terminal

	kafka-console-consumer --bootstrap-server kafka:9092 --topic broker_message --from-beginning

### Kafka Microservices

Abgeleitet von [Tutorial: Write a Kafka Streams Application](https://kafka.apache.org/20/documentation/streams/tutorial).

Startet die Maven Umgebung in Container und wechselt in den Container, nachdem der Container gestartet ist:

	kubectl create -f compiler/maven.yaml
	runbash maven
	
Installiert `git` im Container, falls nicht vorhanden.

	apk update; apk add git

Clont die IoT/Kafka Beispiele compiliert diese und führt sie aus. Die Ergebnisse stehen im Verzeichnis `lernkube/data/src/target`.

	cd /src
	git clone https://github.com/mc-b/iot.kafka.git
	cd iot.kafka
	mvn clean package
	
Kakfa Consumer, empfängt die Nachrichten von der MQTT-Kafka Bridge und gibt diese auf der Console aus:
	
	java -jar target/consumer-service-0.1-jar-with-dependencies.jar
	
Kafka Streams Pipe, empfängt die Nachriten von der MQTT-Kafka Bridge und wandelt diese nach JSON um und leitet sie auf das Topic `iot` weiter:
	
	java -jar target/pipe-service-0.1-jar-with-dependencies.jar
    
Im Terminal sollten die Ausgaben vom IoTKit V3 erscheinen. Siehe [mbed MQTT Client](https://os.mbed.com/teams/mqtt/code/HelloMQTT/).

### Links

* [MQTT Bridge](https://hub.docker.com/r/devicexx/mqtt-kafka-bridge/)
* [mbed MQTT Client](https://os.mbed.com/teams/mqtt/code/HelloMQTT/)
* [Kafka Consumer API](https://kafka.apache.org/20/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html)
* [Kafka Streams](https://kafka.apache.org/documentation/streams/)

### Mosquitto

Mosquitto – Open-Source-MQTT-Broker und Teil des Eclipse-IoT-Projektes (iot.eclipse.org).

Mosquitto Starten

	kubectl create -f devdays/iotmldata/mosquitto.yaml
	
Mosquitto Port (Original 1883) anzeigen  	

	kubectl get services -o wide --selector=app=mosquitto

Mittels den Mosquitto Client Programmen (`apt-get install mosquitto-clients`) oder dem [IoTKit](https://github.com/mc-b/IoTKitV3) können Nachrichten über den Mosquitto Broker gesendet und empfangen werden.

Auf allen Topics horchen:

	mosquitto_sub -p <Mosquitto-Port> -h 192.168.137.100 -t '#'

Daten an Mosquitto Broker senden:

	mosquitto_pub -p <Mosquitto-Port> -h 192.168.137.100 -t mbed/k64f/iotkit/light -m "1.1" -q 0	

#### Links

* [MQTT IoTKit](https://github.com/mc-b/IoTKitV2/tree/master/mqtt)
* [MQTT Publish](https://github.com/mc-b/IoTKitV2/blob/master/mqtt/MQTTPublish)
