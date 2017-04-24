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

router.get('/competition/:id/registration/inBD', function (req, res, next) {
	db.getInformationFromBD(req.params.id, function (result) {
		console.log(result); 
		res.render('../views/allViews/inBD.jade', {inBD: result});
	});
});

router.get('/competition/:id/info', function (req, res, next) {
	db.getSingleCompetition(req.params.id, function (result) {
		res.render('../views/allViews/info.jade', {competition: result});  
	});
});

router.post('/competition/:id/info',function (request, response) {
	if(!request.body) return response.sendStatus(400);
});

router.post('/competition/:id/registration/inBD/answer', urlencodedParser, function (request, response) {
	if(!request.body) return response.sendStatus(400);
	console.log(request.body);  
	response.send(request.body);
});



module.exports = router;
// var getSingleTitle = function (req, res, next) {
// 	req.getSingleTitle = db.getAllCompetitions(function (result) {
// 		return ({competitions: result});
// 	});
// 	console.log(req.getSingleTitle);
// 	next();
// }

// router.use(getSingleTitle);

// var getSingleDetails = function (req, res, next) {
// 	db.getSingleCompetition(req.params.id, function (result) {
// 		console.log(result);
// 		res.render('../views/allViews/competition.jade', {competition: result});  
// 	});
// }
// router.get('/competition/:id/details', [getSingleTitle, getSingleDetails]);

// router.get('/competition/:id/details', function (req, res, next) {
// 	db.getSingleCompetition(req.params.id, function (result) {
// 		console.log(result);
// 		res.render('../views/allViews/competition.jade', {competition: result});  
// 	});
// });

// var cb0 = function (req, res, next) {
//   console.log('CB0');
//   next();
// }

// var cb1 = function (req, res, next) {
//   console.log('CB1');
//   next();
// }

// var cb2 = function (req, res) {
//   res.send('Hello from C!');
// }

// router.get('/example/c', [cb0, cb1, cb2]);
