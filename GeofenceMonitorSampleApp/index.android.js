/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  DeviceEventEmitter,
  StyleSheet,
  Text,
  View
} from 'react-native';

const GeofenceMonitor = require('react-native').NativeModules.GeofenceMonitor;

DeviceEventEmitter.addListener(
  'remoteNotificationReceived',
  function(notifData) {
    console.log('[][] notif data');
    console.log(notifData);
    var data = JSON.parse(notifData.dataJSON);

    PushNotification.localNotification({
        message: data['notificationDetails'], // (required)
    });
  }
);

var PushNotification = require('react-native-push-notification');

PushNotification.configure({
    // (required) Called when a remote or local notification is opened or received
    onNotification: function(notification) {
        console.log( 'NOTIFICATION:', notification );
    },
});

console.log('[][] rawr');
console.log(GeofenceMonitor);
GeofenceMonitor.init(function () {console.log('[][] why??');});
// GeofenceMonitor.addRegion(122.00, -124.00, 100, function (a,b) {
//   console.log('[][] callback hit', a, b);
// });

export default class GeofenceMonitorSampleApp extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('GeofenceMonitorSampleApp', () => GeofenceMonitorSampleApp);
