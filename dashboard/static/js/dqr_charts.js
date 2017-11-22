queue()
    .defer(d3.json, "/get_modules")
	.defer(d3.json, "/get_sensors")
	.defer(d3.json, "/get_power_events")
	.defer(d3.json, "/predict_power_all")
    .await(createDqrGraphics);
	

function createDqrGraphics(error, df_modules, df_sensors, df_power_events, predict_power_all) {
	
	// Helper Functions
	function getModName(modid) {
		for (var mod in df_modules) {
			if (df_modules[mod].MOD_ID == modid)
				return df_modules[mod].MOD_NAME;
		}
		return 'Modulo ' + modid;
	}

	// Clean and Transform dfs Dates
	var tsFormat = d3.time.format("%Y-%m-%d %H:%M:%S");
	var yearMonthFormat = d3.time.format("%Y%m");

	for (var event_id in df_power_events) {
		df_power_events[event_id]["TIMESTAMP"] = tsFormat.parse(df_power_events[event_id]["TIMESTAMP"]);
		df_power_events[event_id]["YEARMONTH"] = yearMonthFormat.parse(df_power_events[event_id]["YEARMONTH"].toString());
	}

	// Create a Crossfilter instance
	var cs_power_monthly_cube = crossfilter(df_power_events);
	var cs_power_acc_cube = crossfilter(df_power_events);
	var cs_predict_power_all_cube = crossfilter(predict_power_all);

	// ------- DIMENSIONS --------
	// Define Dimensions for Accumulated Power Consumption
	var modPowerAccDim = cs_power_acc_cube.dimension(function(d) { return d["MOD_ID"]; });	
	var datePowerAccDim = cs_power_acc_cube.dimension(function (d) { return d.YEARMONTH; });
	
	// Define Dimensions for Monthly Power Consumption
	var datePowerMonthDim = cs_power_monthly_cube.dimension(function (d) { return d.YEARMONTH; });
	var modPowerMonthDim = cs_power_monthly_cube.dimension(function(d) { return d["MOD_ID"]; });
	var datePowerMetricsDim = cs_power_monthly_cube.dimension(function (d) { return d.TIMESTAMP; });

	// Define Dimensions for Power Prediction
	var predictPowModDim = cs_predict_power_all_cube.dimension(function(d) { return d["MOD_ID"]; });
	
	// ------- METRICS --------
	// Metrics for numbers (prediction and events)
	var eventCount = cs_power_monthly_cube.groupAll().reduceCount();
	var predictPowerAll = cs_predict_power_all_cube.groupAll().reduceSum(function(d) {return d["WATT_HOUR_MONTH"];});
	
	// Metrics for power consumption accumulated
	var powerAccDataByMod = modPowerAccDim.group().reduceSum(function(d) {return d.WATT_HOUR / 1000;});
	var currentMonthStart = d3.time.month(new Date());
	datePowerAccDim.filter(currentMonthStart);
	
	// Metrics for Monthly power consumption
	var powerMonthDataByMod = modPowerMonthDim.group().reduce( reduceAddAvg, reduceRemoveAvg, reduceInitialAvg );
	var powerMonthDataByMonth = datePowerMonthDim.group().reduceSum(function(d) {return d.WATT_HOUR / 1000;});
	var powerMetrics = datePowerMetricsDim.group().reduceSum(function(d) {return d.WATT_HOUR;});

	// ------- CHARTS --------
	// Chart Range Variables (Domain)
	var minMonthPower = datePowerMetricsDim.bottom(1)[0]["TIMESTAMP"];
	var maxMonthPower = datePowerMetricsDim.top(1)[0]["TIMESTAMP"];
	
	// Chart Initializations
	var sensorChart = dc.lineChart("#sensing_time_chart");
	var rangeSensorChart = dc.barChart('#sensing_time_range');
	var eventCountND = dc.numberDisplay("#events_count_number");
	var predictPowerAllND = dc.numberDisplay("#power_prediction_graph");
	var powerAccChart = dc.rowChart("#top_acc_power_bar");
	var topPowerMonthlyModsChart = dc.rowChart("#top_monthly_power_bar");
	var powerMonthlyChart = dc.barChart("#monthly_power_bar");
	
	// Chart Configurations
	rangeSensorChart
		.height(40)
		.width(600)
		.margins({top: 0, right: 50, bottom: 30, left: 50})
		.dimension(datePowerMetricsDim)
		.group(powerMetrics)
		.x(d3.time.scale().domain([minMonthPower, maxMonthPower]))
		.xUnits(d3.time.month)
		.colors('#99CC99')
		.centerBar(true);
	sensorChart
		.width(600)
		.height(180)
		.margins({top: 10, right: 50, bottom: 30, left: 50})
		.rangeChart(rangeSensorChart)
		.dimension(datePowerMetricsDim)
		.group(powerMetrics)
		.xUnits(d3.time.day)
		.brushOn(false)
		.mouseZoomable(true)
		.zoomScale([1, 100])
		.zoomOutRestrict(true)
		.transitionDuration(0)
		.renderVerticalGridLines(true)
		.title(function(d){return (Math.round(d.value * 100) / 100) + ' Watt/h';})
		.x(d3.time.scale().domain([minMonthPower, maxMonthPower]))
		.elasticY(true)
		.colors('#55AA55')
		.yAxisLabel("Watt/h")
		.yAxis().ticks(5);
	//sensorChart.on('zoomed', function(chart, filter){console.log(chart); console.log(filter);})
		
	eventCountND
		.valueAccessor(function(d){return d; })
		.group(eventCount)
		.formatNumber(d3.format(".3s"));
		
	predictPowerAllND
		.valueAccessor(function(d){return d; })
		.group(predictPowerAll)
		.formatNumber(d3.format(".3s"))
		.on('postRender', function() { $('span.power_prediction_graph').css('display', 'inherit'); });
	
	powerAccChart
        .width(300)
        .height(250)
        .dimension(modPowerAccDim)
		.transitionDuration(500)
        .group(powerAccDataByMod)
		.title(function(d){return (Math.round(d.value * 100) / 100) + ' kWatt/h';})
		.label(function (d){ return getModName(d.key); })
		.colors(d3.scale.category10())
        .xAxis().ticks(6);
	//powerAccChart.legend(dc.legend().legendText(function(d) { return d.name + ': ' d.data; }));
	
	topPowerMonthlyModsChart
		.width(300)
        .height(250)
        .dimension(modPowerMonthDim)
		.transitionDuration(500)
		.valueAccessor(function (d) { return d.value.avg; })
		.title(function(d){return (Math.round(d.value.avg * 100) / 100) + ' Watt/h';})
		.label(function (d){ return getModName(d.key); })
        .group(powerMonthDataByMod)
		.colors(d3.scale.category10())
        .xAxis().ticks(6);
	
	powerMonthlyChart
		.width(600)
		.height(400)
		.margins({top: 10, right: 50, bottom: 30, left: 50})
		.dimension(datePowerMonthDim)
		.group(powerMonthDataByMonth)
		//.xUnits(d3.time.day)
		//.xUnits(function(){return 20;})
		.xUnits(dc.units.ordinal)
		.transitionDuration(500)
		//.x(d3.time.scale().domain([minMonth, maxMonth]))
		.x(d3.scale.ordinal())
		.brushOn(false)
		//.x(d3.scale.ordinal().domain(df_power_events.map(function (d) {return d.YEARMONTH; })))
		//.x(d3.scale.linear().domain([minMonth, maxMonth]))
		.elasticY(true)
		.title(function(d){return (Math.round(d.value * 100) / 100) + ' kWatt/h';})
		//.colors(d3.scale.category10())
		.yAxis().ticks(5);
	powerMonthlyChart.xAxis().tickFormat(function(d) { return d3.time.format("%b")(d); });
	powerMonthlyChart.addFilterHandler(function (filters, filter) {
											filters.length = 0;
											filters.push(filter);
											return filters;
										});
		
	dc.renderAll();
	
	// Events
	$('#sensing_time_select_mod').on('change', function () {
		modIdDim.filterAll();
		modIdDim.filter(this.value);
		dc.redrawAll();
	});

};


// Reduce Functions
function reduceAddAvg(p, v) {
	++p.events;
	p.total += v.WATT_HOUR;
	p.avg = Math.round(p.total / p.events * 100) / 100;
	return p;
}
function reduceRemoveAvg(p, v) {
	--p.events;
	p.total -= v.WATT_HOUR;
	p.avg = p.events ? Math.round(p.total / p.events * 100) / 100 : 0;
	return p;
}
function reduceInitialAvg() {
	return {events: 0, total: 0, avg: 0};
}


// Eventos

$(document).ready(function(){
	
});