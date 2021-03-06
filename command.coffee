dashdash       = require 'dashdash'
ReporterRunner = require './src/reporter-runner'

options = [
  {
    name: 'version'
    type: 'bool'
    help: 'Print tool version and exit.'
  }
  {
    names: ['help', 'h']
    type: 'bool'
    help: 'Print this help and exit.'
  }
  {
    name: 'dry-run'
    type: 'bool'
    help: 'Print results, do not post to statuspage.io'
  }
  {
    names: ['elasticsearch-uri', 'e']
    type: 'string'
    env: 'ELASTICSEARCH_URI'
    help: 'ElasticSearch URI'
    helpArg: 'URI'
  }
  {
    name: 'meshblu-sample-rate'
    type: 'string'
    env: 'MESHBLU_SAMPLE_RATE'
    help: 'Meshblu Sample Rate'
    default: '0.001'
  }
  {
    names: ['statuspage-api-key', 'k']
    type: 'string'
    env: 'STATUSPAGE_API_KEY'
    help: 'StatusPage.io API key'
  }
  {
    names: ['statuspage-page-id', 'p']
    type: 'string'
    env: 'STATUSPAGE_PAGE_ID'
    help: 'StatusPage.io Page ID'
  }
  {
    names: ['forever', 'f']
    type: 'bool'
    env: 'FOREVER'
    help: 'Use forever mode. (default: false)'
    default: false
  }
  {
    names: ['interval', 'i']
    type: 'integer'
    env: 'INTERVAL_SECONDS'
    help: 'Interval delay in seconds when running in forever mode'
    default: 60
  }
  {
    names: ['cluster', 'c']
    type: 'string'
    env: 'CLUSTER'
    help: 'Cluster to use'
  }
]

parser = dashdash.createParser(options: options)
try
  opts = parser.parse(process.argv)
catch e
  console.error 'elastic-search-to-statuspage: error: %s', e.message
  process.exit 1

if opts.help
  help = parser.help({includeEnv: true,includeDefaults: true}).trimRight()
  console.log 'usage: node command.js [OPTIONS]\n' + 'options:\n' + help
  process.exit 0

options = {
  cluster: opts.cluster,
  pageId: opts.statuspage_page_id,
  statusPageApiKey: opts.statuspage_api_key,
  elasticSearchUri: opts.elasticsearch_uri,
  meshbluSampleRate: opts.meshblu_sample_rate,
  timeoutSeconds: opts.timeout,
  forever: opts.forever,
  dryRun: opts.dry_run,
}
reporterRunner = new ReporterRunner options
reporterRunner.run (error) =>
  if error
    console.error error.stack
    process.exit 1
  process.exit 0
