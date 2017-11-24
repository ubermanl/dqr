// The global variable sensor_id is set inside the html template for the requested sensor

queue()
    .defer(d3.json, "/get_modules")
	.defer(d3.json, "/get_sensors")
	.defer(d3.json, "/get_events?sensor_type_id=" + sensor_id)
    .await(createDqrGraphics);

function createDqrGraphics(error, df_modules, df_sensors, df_events) {

	// Helper Functions
	function getModName(modid) {
		for (var mod in df_modules) {
			if (df_modules[mod].MOD_ID == modid)
				return df_modules[mod].MOD_NAME;
		}
		return 'Modulo ' + modid;
	}
	function getSensorUnit(sensor_id) {
		for (var sensor in df_sensors) {
			if (df_sensors[sensor].SENSOR_TYPE_ID == sensor_id)
				return df_sensors[sensor].UNIT;
		}
		return 'Sensor ' + sensor_id;
	}
	var sensor_unit = getSensorUnit(sensor_id);
	
	// Setting default module_id
	module_id = df_modules[0].MOD_ID;
	
	// Print Module Selector
	var options_html = '';
	for (var mod in df_modules) {
		options_html += '<option value=' + df_modules[mod].MOD_ID + '>' + df_modules[mod].MOD_NAME + '</option>';
	}
	$('#sensing_time_select_mod').html(options_html);

	// Clean and Transform dfs Dates
	var tsFormat = d3.time.format("%Y-%m-%d %H:%M:%S");

	for (var event_id in df_events) {
		df_events[event_id]["TIMESTAMP"] = tsFormat.parse(df_events[event_id]["TIMESTAMP"]);
	}

	// Create a Crossfilter instance
	var cs_events_cube = crossfilter(df_events);

	// ------- DIMENSIONS --------
	// Define Dimensions for Accumulated Power Consumption
	var modEventsDim = cs_events_cube.dimension(function(d) { return d.MOD_ID; });	
	var dateEventsDim = cs_events_cube.dimension(function (d) { return d.TIMESTAMP; });
		
	// ------- METRICS --------
	var eventsDatabyDate = dateEventsDim.group().reduceSum( function(d) {return d.SENSED_VALUE;} );
	modEventsDim.filter(module_id);
	
	// ------- CHARTS --------
	// Chart Range Variables (Domain)
	var minDataDate = dateEventsDim.bottom(1)[0]["TIMESTAMP"];
	var maxDataDate = dateEventsDim.top(1)[0]["TIMESTAMP"];
	
	// Chart Initializations
	var dataTimeChart = dc.lineChart('#sensing_time_chart');
	var timeRangeChart = dc.barChart('#sensing_time_range');
	
	// Chart Configurations
	timeRangeChart
		.height(50)
		.width(1200)
		.margins({top: 0, right: 50, bottom: 30, left: 50})
		.dimension(dateEventsDim)
		.group(eventsDatabyDate)
		.x(d3.time.scale().domain([minDataDate, maxDataDate]))
		.xUnits(d3.time.month)
		.colors('#99CC99')
		.centerBar(true);
	dataTimeChart
		.width(1200)
		.height(400)
		.margins({top: 10, right: 50, bottom: 30, left: 50})
		.rangeChart(timeRangeChart)
		.dimension(dateEventsDim)
		.group(eventsDatabyDate)
		.xUnits(d3.time.hour)
		.brushOn(false)
		.mouseZoomable(true)
		.zoomScale([1, 100])
		.zoomOutRestrict(true)
		.transitionDuration(0)
		.renderVerticalGridLines(true)
		.title(function(d){return (Math.round(d.value * 100) / 100) + ' ' + sensor_unit;})
		.x(d3.time.scale().domain([minDataDate, maxDataDate]))
		.elasticY(true)
		.colors('#55AA55')
		.yAxisLabel(sensor_unit)
		.yAxis().ticks(5);
	// Following Event prevents displaying the chart if there's no datapoints to show
	dataTimeChart.on('postRedraw', function(chart) {
										if (cs_events_cube.groupAll().reduceCount().value() < 1) {
											$('#sensing_time_chart').css('display','none');
											$('#sensing_time_chart_insufficient').css('display','inherit');
										} else {
											$('#sensing_time_chart').css('display','inherit');
											$('#sensing_time_chart_insufficient').css('display','none');
										} });
				
	dc.renderAll();
	
	// Events
	$('#sensing_time_select_mod').on('change', function () {
		modEventsDim.filterAll();
		modEventsDim.filter(this.value);
		dc.redrawAll();
	});

};

// Reduce Functions
function reduceAddAvg(p, v) {
	++p.events;
	p.total += v.SENSED_VALUE;
	p.avg = Math.round(p.total / p.events * 100) / 100;
	return p;
}
function reduceRemoveAvg(p, v) {
	--p.events;
	p.total -= v.SENSED_VALUE;
	p.avg = p.events ? Math.round(p.total / p.events * 100) / 100 : 0;
	return p;
}
function reduceInitialAvg() {
	return {events: 0, total: 0, avg: 0};
}
