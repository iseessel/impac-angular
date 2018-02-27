angular
.module('impac.services.highcharts-theme', [])
.service('HighchartsThemeService', () ->

  Highcharts.theme =
  colors: [
    '#7cb5ec'
    '#f7a35c'
    '#90ee7e'
    '#7798BF'
    '#aaeeee'
    '#ff0066'
    '#eeaaee'
    '#55BF3B'
    '#DF5353'
    '#7798BF'
    '#aaeeee'
  ]
  chart:
    backgroundColor: null
  title: style:
    fontSize: '16px'
    fontWeight: 'bold'
    textTransform: 'uppercase'
  tooltip:
    borderWidth: 0
    backgroundColor: 'rgba(219,219,216,0.8)'
    shadow: true
  legend: itemStyle:
    fontWeight: 'bold'
    fontSize: '13px'
  xAxis:
    labels: style: fontSize: '10px'
  yAxis:
    minorTickInterval: 'auto'
    title: style: textTransform: 'uppercase'
    labels: style: fontSize: '12px'
  plotOptions: candlestick: lineColor: '#404048'
  background2: '#F0F0EA'

  # Apply the theme
  Highcharts.setOptions Highcharts.theme

)