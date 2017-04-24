var Firebird = require('node-firebird');

var options = {
	database: 'D:/Pars/3 course/2 semester/DataBase/Coursework/Coursework/public/bd/COURSEWORK_VER2.FDB',
	port: 3050,
	user: 'SYSDBA',
	password: 'masterkey',
	lowercase_keys: false, // set to true to lowercase keys
	role: null,			   // default
	pageSize: 4096		   // default when creating database
};


/*------------------------------ UTILITY -------------------------------*/
function ab2str(buf) {
	return String.fromCharCode.apply(null, new Uint16Array(buf));
}

function str2ab(str) {
   var buf = new ArrayBuffer(str.length * 2); // 2 bytes for each char
   var bufView = new Uint16Array(buf);
   for (var i=0, strLen=str.length; i < strLen; i ++) {
   	bufView[i] = str.charCodeAt(i);
   }
   return buf;
}

function extendArray (array1, array2) {
	var moreInformation = {moreInformation: array2};
	[].push.apply(array1, moreInformation); 
}

/*------------------------------ CONNECT/DISCONNECT -------------------------------*/

// connectToDB = function (request) {
// 	console.log(request);
// }
disconnectFromDB = function() {
	console.log('DATABASE DETACHED');
};

function getAllCompetitions (callback) {
/*--------------------------------- REQUEST ---------------------------------------*/

	Firebird.attach(options, function(err, db){
		if (err) {
			console.log(err.message);
			throw err;
		} else {
			console.log("DATABASE (getAllCompetitions) CONNECTED");
			db.query(`
					select Competitions.IdCompetition, Competitions.Title, 
					   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
					      Competitions.Organizers, Competitions.Country, count(Couples.codePartner)
					from Competitions, Couples
					group by Competitions.IdCompetition, Competitions.Title, 
					   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
					      Competitions.Organizers, Competitions.Country;
				`, function(err, result) {
				if (err) {
					console.log(err);
					db.detach(disconnectFromDB());
				} else {
					db.detach(disconnectFromDB());
					//console.log(result.name);
					callback(result);
				}
			});		
		}
	});
}

function getSingleCompetition (req, callback) {
/*--------------------------------- REQUEST ---------------------------------------*/
	Firebird.attach(options, function(err, db){
		if (err) {
			console.log(err.message);
			throw err;
		} else {
			console.log("DATABASE (getSingleCompetition) CONNECTED");
			db.query(`
				select Competitions.IdCompetition, Competitions.Title, 
				   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
				      Competitions.Organizers, Competitions.Country, count(Couples.codePartner)
				from Competitions, Couples
				where Competitions.IdCompetition =?
				group by Competitions.IdCompetition, Competitions.Title, 
				   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
				      Competitions.Organizers, Competitions.Country;
      		`, [req], function(err, result1) {
				if (err) {
					console.log(err);
					db.detach(disconnectFromDB());
				} else {
					db.query(`
						select Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram, count(Couples.PairNumber)
						from Competitions 
						   INNER JOIN BallroomPrograms 
						      ON Competitions.idCompetition = BallroomPrograms.idCompetition
						   INNER JOIN Categories 
						      ON BallroomPrograms.idCompetition = Categories.idCompetition
						   INNER JOIN consistClass
						      ON Categories.idCompetition = consistClass.idCompetition
						         and Categories.idProgram = consistClass.idProgram
						            and Categories.CategoryID = consistClass.CategoryID
						   INNER JOIN Classes
						      ON consistClass.ClassID = Classes.ClassID
						         and BallroomPrograms.idProgram = Categories.idProgram
						   LEFT JOIN Couples
						      ON Categories.idCompetition = Couples.idCompetition
						         and Categories.idProgram = Couples.idProgram
						            and Categories.CategoryID = Couples.CategoryID
						               and Couples.ClassID = Classes.ClassID
						where Competitions.idCompetition =?
						group by Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram
						order by Classes.ClassName DESC, Categories.CategoryName DESC, BallroomPrograms.typeOfProgram DESC;
						`, [req],function(err, result2) {
						if (err) {
							console.log(err);
							db.detach(disconnectFromDB());
						} else {
							db.detach(disconnectFromDB());
							result1['moreInformation'] = result2;
							callback(result1);
						}
					});
				}
			});		
		}
	});
}

function getInfoSingleCategory (req, callback) {
/*--------------------------------- REQUEST ---------------------------------------*/

	Firebird.attach(options, function(err, db){
		if (err) {
			console.log(err.message);
			throw err;
		} else {
			console.log("DATABASE (getInfoSingleCategory) CONNECTED");
			console.log(req.id, req.category, req.class, req.program);
			db.query(`SELECT DISTINCT Couples.PairNumber, Couples.surnamePartner, Couples.namePartner,
					   Partners.Country, Couples.surnameShepartner, Couples.nameShepartner, Shepartners.Country,
					   Classes.ClassName, Categories.CategoryName, BallroomPrograms.typeOfProgram
					from Couples, Partners, Shepartners, Categories, Classes, BallroomPrograms, consistClass
					where Couples.codePartner = Partners.codePartner 
					   and Couples.codeShePartner = Shepartners.codeShePartner
					   and Couples.ClassID = Classes.ClassID
					   and Couples.IdProgram = Categories.IdProgram
					   and Couples.CategoryID = Categories.CategoryID
					   and Couples.CategoryID = consistClass.CategoryID
					   and Couples.IdProgram = BallroomPrograms.IdProgram
					   and Categories.IdProgram = BallroomPrograms.IdProgram
					   and consistClass.IdProgram = Categories.IdProgram
					   and consistClass.CategoryID = Categories.CategoryID 
					   and BallroomPrograms.idcompetition =?
					   and Categories.CategoryName =?
					   and Classes.ClassName =?
					   and BallroomPrograms.typeOfProgram =?
					order by Couples.PairNumber, BallroomPrograms.typeOfProgram DESC
			`, [req.id, req.category, req.class, req.program], function(err, result) {
				if (err) {
					console.log(err);
					db.detach(disconnectFromDB());
				} else {
					db.detach(disconnectFromDB());
					result['idCompetition'] = req.id;
					callback(result);
				}
			});		
		}
	});
}

function getInformationFromBD (req, callback) {
/*--------------------------------- REQUEST ---------------------------------------*/
	Firebird.attach(options, function(err, db){
		if (err) {
			console.log(err.message);
			throw err;
		} else {
			console.log("DATABASE (getInformationFromBD) CONNECTED");
			db.query(`
				select Competitions.IdCompetition, Competitions.Title, 
				   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
				      Competitions.Organizers, Competitions.Country, count(Couples.codePartner)
				from Competitions, Couples
				where Competitions.IdCompetition =?
				group by Competitions.IdCompetition, Competitions.Title, 
				   Competitions.DateCompetition, Competitions.Place, Competitions.Rules, 
				      Competitions.Organizers, Competitions.Country;
      		`, [req], function(err, result1) {
				if (err) {
					console.log(err);
					db.detach(disconnectFromDB());
				} else {
					db.query(`
						select * from Partners;`, function(err, result2) {
						if (err) {
							console.log(err);
							db.detach(disconnectFromDB());
						} else {
							result1['Partners'] = result2;
							db.query(`
								select * from ShePartners;`, function(err, result3) {
								if (err) {
									console.log(err);
									db.detach(disconnectFromDB());
								} else {
									result1['ShePartners'] = result3;
									db.query(`select * from Coaches;`, function(err, result4) {
										if (err) {
											console.log(err);
											db.detach(disconnectFromDB());
										} else {
											result1['Coaches'] = result4;
											db.query(`select Classes.ClassID, Classes.ClassName
											from Competitions, Classes
											where Competitions.IdCompetition =?;
											`, [req],function(err, result5) {
												if (err) {
													console.log(err);
													db.detach(disconnectFromDB());
												} else {
													result1['Classes'] = result5;
													db.query(`select Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram
													from Competitions 
													   INNER JOIN BallroomPrograms 
													      ON Competitions.idCompetition = BallroomPrograms.idCompetition
													   INNER JOIN Categories 
													      ON BallroomPrograms.idCompetition = Categories.idCompetition
													   INNER JOIN consistClass
													      ON Categories.idCompetition = consistClass.idCompetition
													         and Categories.idProgram = consistClass.idProgram
													            and Categories.CategoryID = consistClass.CategoryID
													   INNER JOIN Classes
													      ON consistClass.ClassID = Classes.ClassID
													         and BallroomPrograms.idProgram = Categories.idProgram
													where Competitions.idCompetition =?
													group by Categories.CategoryName, Classes.ClassName, BallroomPrograms.typeOfProgram
													order by Classes.ClassName DESC, Categories.CategoryName DESC, BallroomPrograms.typeOfProgram DESC;
													`, [req],function(err, result5) {
														if (err) {
															console.log(err);
															db.detach(disconnectFromDB());
														} else {
															db.detach(disconnectFromDB());
															result1['Classes'] = result5;
															callback(result1);
														}
													});
												}
											});
										}
									});
								}
							});
						}
					});
				}
			});		
		}
	});
}







module.exports = {
	getAllCompetitions: getAllCompetitions,
	getSingleCompetition: getSingleCompetition,
	getInfoSingleCategory: getInfoSingleCategory,
	getInformationFromBD: getInformationFromBD
}