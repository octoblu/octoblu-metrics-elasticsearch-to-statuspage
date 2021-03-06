_     = require 'lodash'
query = require '../queries/meshblu-mqtt-average-response-time.cson'
debug   = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:meshblu-mqtt-average-response-time')

METRIC_IDS=
  'hpe': 'shm8wkm2p8cx'
  'major': 'n8tkgcd1vy76'
  'minor': 'n8tkgcd1vy76'

class MeshbluMqttAverageResponseTimeReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.search query, (error, results, statusCode) =>
      return callback error if error?
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      debug 'reporting', data
      @statusPageReporter.post @metricId, data, callback

module.exports = MeshbluMqttAverageResponseTimeReporter
