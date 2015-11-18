var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PrescriptionSchema = new Schema({
	// object id of medication
	medication_assigned: String,
    instructions: String,
    alert_assigned: [String]
});

module.exports = mongoose.model('Prescription', PrescriptionSchema);