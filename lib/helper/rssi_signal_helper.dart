class RssiSignal {
  static String rssiTranslator(int rssi) {
    if (rssi >= -50) {
      return 'Excellent';
    } else if (rssi >= -60) {
      return 'Very Good';
    } else if (rssi >= -70) {
      return 'Good';
    } else if (rssi >= -80) {
      return 'Low';
    } else if (rssi >= -90) {
      return 'Very Low';
    } else if (rssi >= -100) {
      return 'Extremely slow';
    } else if (rssi == 0) {
      return 'No Signal';
    } else {
      return 'Unknown';
    }
  }
}
