var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var urlencodedParser = bodyParser.urlencoded({ extended: false });
var db = require('./queries.js');

/* GET home page. */
router.get('/', function(req, res, next) {
	res.render('../views/allViews/main.jade', {title: 'My Coursework'});
});


router.get('/competitions', function (req, res, next) {
	db.getAllCompetitions(function (result) {
		res.render('../views/allViews/competitions.jade', {competitions: result}); 
	});
});


router.get('/competition/:id/details', function (req, res, next) {
	db.getSingleCompetition(req.params.id, function (result) { 
		res.render('../views/allViews/competition.jade', {competition: result});
	});
});

router.get('/competition/:id/oneCategory/:category/:class/:program', function (req, res, next) {
	db.getInfoSingleCategory(req.params, function (result) {
		// console.log(result);
		// console.log(result.idCompetition);
		res.render('../views/allViews/oneCategory.jade', {infoSingleCategory: result});
	});
});

router.get('/competition/:id/registration', function (req, res, next) {
	db.getSingleCompetition(req.params.id, function (result) { 
		res.render('../views/allViews/registration.jade', {registration: result});
	});
});

router.get('/competition/:id/registration/inDB', function (req, res, next) {
	db.getInformationFromDB(req.params.id, function (result) {
		//console.log(result); 
		res.render('../views/allViews/inDB.jade', {inDB: result});
	});
});

router.get('/competition/:id/info', function (req, res, next) {
	db.getSingleCompetition(req.params.id, function (result) {
		res.render('../views/allViews/info.jade', {competition: result});  
	});
});


router.post('/competition/:id/registration/inDB/answer', urlencodedParser, function(request, response) {
	if(!request.body) return response.sendStatus(400);
	console.log(request.body);
	request.body.idCompetition = request.params.id;
	db.addCouple(request.body, function (result) {

		db.getInfoFromSingleCompetition(request.params.id, function (allInformation) {
			result.info = allInformation[0];
			console.log(result);

			response.render('../views/allViews/answer.jade', {answer: result});
		});
	});
});



module.exports = router;
