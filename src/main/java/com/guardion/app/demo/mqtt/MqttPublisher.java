package com.guardion.app.demo.mqtt;

import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@Service
public class MqttPublisher {

	private IMqttClient mqttClient;

	@PostConstruct
	public void init() throws MqttException {
		String publisherId = "spring-boot-pub";
		mqttClient = new MqttClient("tcp://localhost:1883", publisherId);
		mqttClient.connect();
	}

	public void publish(String topic, String payload) throws MqttException {
		if (!mqttClient.isConnected()) {
			mqttClient.connect();
		}

		MqttMessage message = new MqttMessage();
		message.setPayload(payload.getBytes());
		message.setQos(1); // QoS 0, 1, or 2
		mqttClient.publish(topic, message);
	}
}
