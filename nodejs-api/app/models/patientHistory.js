var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PatientHistorySchema = new Schema({
	patient_assigned: String,
	alert_assigned: String,
	taken: Boolean,
	date: Date
});

module.exports = mongoose.model('PatientHistory', PatientHistorySchema);