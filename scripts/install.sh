#!/bin/bash
#
#	Installationsscript devdays

# Abhaengige Images
docker pull confluentinc/cp-kafka:latest
docker pull confluentinc/cp-zookeeper:latest
docker pull devicexx/mqtt-kafka-bridge 

# Jupyter Machine Learning Umgebung (zuerst pull, weil Image sehr, sehr gross)
docker pull misegr/jupyter-mlg
kubectl create -f https://raw.githubusercontent.com/mc-b/mlg/master/jupyter/jupyter-mlg.yaml

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/

# DevOps Beispiele
kubectl create ns production

# Aufraeumen um Speicher zu sparen
kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base.yaml 
kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml

