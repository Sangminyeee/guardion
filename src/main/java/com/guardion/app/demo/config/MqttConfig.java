// package com.guardion.app.demo.config;
//
// import java.util.UUID;
//
// import org.eclipse.paho.client.mqttv3.MqttClient;
// import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
// import org.eclipse.paho.client.mqttv3.MqttException;
// import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
//
// import com.guardion.app.demo.mqtt.MqttMessageHandler;
//
// @Configuration
// public class MqttConfig {
//
// 	@Value("${mqtt.broker}")
// 	private String broker;
//
// 	@Value("${mqtt.client-id}")
// 	private String clientId;
//
// 	@Value("${mqtt.sub-topic}")
// 	private String topic; //테스트용
//
// 	@Bean
// 	public MqttClient mqttClient(MqttMessageHandler handler) throws MqttException {
// 		String uniqueClientId = clientId + "-" + UUID.randomUUID();
// 		MqttClient client = new MqttClient(broker, uniqueClientId, new MemoryPersistence());
//
// 		MqttConnectOptions options = new MqttConnectOptions();
// 		options.setAutomaticReconnect(true);
// 		options.setCleanSession(true);
// 		client.connect(options);
// 		client.subscribe(topic, handler::messageArrived); //테스트용
// 		return client;
// 	}
// }
