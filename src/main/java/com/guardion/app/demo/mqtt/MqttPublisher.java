package com.guardion.app.demo.mqtt;

import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;

import jakarta.annotation.PostConstruct;

@Service
public class MqttPublisher {

	private MqttClient client;

	@Value("${mqtt.broker}")
	private String broker;

	@Value("${mqtt.publisher-id}")
	private String publisherId;

	@PostConstruct
	public void init() {
		try {
			client = new MqttClient(broker, publisherId);
			client.connect();
		} catch (MqttException e) {
			throw new BusinessException(ErrorCode.MQTT_CONNECTION_ERROR);
		}
	}

	public void publish(String topic, String payload) {
		try {
			if (!client.isConnected()) {
				client.connect();
			}

			MqttMessage message = new MqttMessage();
			message.setPayload(payload.getBytes());
			message.setQos(1); // QoS 0, 1, or 2
			client.publish(topic, message);
		} catch (MqttException e) {
			throw new BusinessException(ErrorCode.MQTT_PUBLISH_ERROR);
		}
	}
}
