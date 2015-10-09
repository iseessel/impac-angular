module = angular.module('impac.components.widgets.sales-leads-funnel',[])

module.controller('WidgetSalesLeadsFunnelCtrl', ($scope, Utilities, ChartFormatterSvc, $filter) ->

    w = $scope.widget

    w.initContext = ->
      if $scope.isDataFound = angular.isDefined(w.content) && !_.isEmpty(w.content.leads_per_status)

        $scope.statusOptions = _.compact _.map w.metadata.status_selection, (status) ->
          {label: status, selected: true} if angular.isDefined(w.content.leads_per_status[status])

        angular.forEach w.content.leads_per_status, (value, status) ->
          if w.metadata.status_selection && !(status in w.metadata.status_selection)
            $scope.statusOptions.push({label: status, selected: false})
          else if _.isEmpty(w.metadata.status_selection)
            $scope.statusOptions.push({label: status, selected: true})


    w.format = ->
      if $scope.isDataFound
        max=0
        angular.forEach  $scope.statusOptions, (statusOption) ->
          value = w.content.leads_per_status[statusOption.label].total
          max = value if statusOption.selected && angular.isDefined(value) && value > max

        if max > 0
          $scope.funnel = _.compact _.map $scope.statusOptions, (statusOption, index) ->
            value = w.content.leads_per_status[statusOption.label].total
            coloredWidth = (100 * (value / max) - 10).toFixed()
            if coloredWidth < 8
              statusWidth = 92
            else
              statusWidth = 100 - coloredWidth
            {
              status: statusOption.label,
              number: value,
              coloredWidth: {width: "#{coloredWidth}%"}
              statusWidth: {width: "#{statusWidth}%"}
            } if statusOption.selected && angular.isDefined(value)

    $scope.getImpacColor = (index) ->
      ChartFormatterSvc.getColor(index)

    $scope.toggleSelectStatus = (aStatus) ->
      if $scope.selectedStatus && $scope.selectedStatus == aStatus
        $scope.selectedStatus = null
      else
        $scope.selectedStatus = aStatus

      if !w.isExpanded() && $scope.selectedStatus
        # will trigger updateSettings(false)
        w.toggleExpanded()
      else
        w.updateSettings(false)

    $scope.isSelected = (aStatus) ->
      return $scope.selectedStatus && aStatus == $scope.selectedStatus

    $scope.getSelectedLeads = ->
      if $scope.isDataFound && $scope.selectedStatus
        return w.content.leads_per_status[$scope.selectedStatus].leads

    $scope.getLeadDescription = (aLead) ->
      tooltip = []

      nameLineArray = ["<strong>"]
      nameLineArray.push($filter('titleize')(aLead.first_name)) if aLead.first_name
      nameLineArray.push($filter('titleize')(aLead.last_name)) if aLead.last_name
      nameLineArray.push("</strong>")

      tooltip.push(nameLineArray.join(' '))
      tooltip.push("Status: #{$filter('titleize')(aLead.lead_status)}")
      tooltip.push("Organization: #{$filter('titleize')(aLead.organization)}") if aLead.organization

      if aLead.opportunities
        tooltip.push("<strong>Opportunities:</strong>")
        angular.forEach aLead.opportunities, (opp) ->
          oppLineArray = []
          oppLineArray.push("##{opp.code}") if opp.code
          oppLineArray.push("#{opp.name}") if opp.name
          # TODO currency
          oppLineArray.push($filter('mnoCurrency')(opp.amount.total_amount, "USD", false)) if opp.amount
          oppLineArray.push("#{opp.probability}%") if opp.probability
          oppLineArray.push("#{opp.sales_stage}") if opp.sales_stage
          tooltip.push(oppLineArray.join(' - '))

      return tooltip.join("<br />")


    selectedStatusSetting = {}
    selectedStatusSetting.initialized = false

    selectedStatusSetting.initialize = ->
      $scope.selectedStatus = w.metadata.selected_status if angular.isDefined(w.content.leads_per_status[w.metadata.selected_status])
      selectedStatusSetting.initialized = true

    selectedStatusSetting.toMetadata = ->
      {selected_status: $scope.selectedStatus}

    w.settings.push(selectedStatusSetting)



    # TODO: Refactor once we have understood exactly how the angularjs compilation process works:
    # in this order, we should:
    # 1- compile impac-widget controller
    # 2- compile the specific widget template/controller
    # 3- compile the settings templates/controllers
    # 4- call widget.loadContent() (ideally, from impac-widget, once a callback
    #     assessing that everything is compiled an ready is received)
    getSettingsCount = ->
      if w.settings?
        return w.settings.length
      else
        return 0

    # time range + organizations + params picker + width + status selector
    $scope.$watch getSettingsCount, (total) ->
      w.loadContent() if total >= 5

    return w
)

module.directive('widgetSalesLeadsFunnel', ->
  return {
    restrict: 'A',
    controller: 'WidgetSalesLeadsFunnelCtrl'
  }
)