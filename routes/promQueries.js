const Firebird = require('node-firebird');
const Promise = require('bluebird');
const dbOptions = require('./dbOptions.js');
var db;

const options = dbOptions.options;


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

connectToDB = dboptions => {
	const def = Promise.defer();

    Firebird.attach(dboptions,
		(err, db) => {
        	err ? def.reject(err) : def.resolve(db);
      	}
    );
    return def.promise;	
}

function disconnectFromDB() {
	db.detach(() => {console.log('DATABASE DETACHED')});
};

/*------------------------------ QUERY -------------------------------*/

queryDB = (sql) => {
	const def = Promise.defer();

	connectToDB(options).then(
	  	// success
	  	dbconn => {
			db = dbconn;
			db.query(sql, (err, rs) => {
				err ? def.reject(err) : def.resolve(rs);
			});
	  	},
	  	// fail
	  	err => {
	    	console.log(err);
	  	});
		return def.promise;
	};

const addNewHumanInDB = (objHuman, typeOfHuman, req) => {
	

	connectToDB(options).then(
	  	// success
	  	dbconn => {
			db = dbconn;
			db.query(checkID, (err, rs) => {
				if (err) {
					def.reject(err);
				} else {
					def.resolve(addHuman);

				}
			});
	  	},
	  	// fail
	  	err => {
	    	console.log(err);
	  	}
	);
	return def.promise;
};


const addNewHumanSql = (typeOfHuman, objHuman, name, surname, patronymic, county) => {
	const isPatronymic = patronymic === "" ? 'null' : `'${patronymic}'`;
	let parseObj = ``;
	let codeHuman = objHuman[0];
	console.log('name', name, 'surname', surname, 'patronymic', patronymic, 'county', county)
	objHuman.forEach((item) => {
		if (objHuman[objHuman.length - 1] == item && item !== objHuman[0]) {
			parseObj += item;
		} else if (item === objHuman[0]) {
			return;
		} else {
			parseObj += item + ', '; 
		}
	});
	return`
		INSERT INTO ${typeOfHuman} (${parseObj})
   		VALUES ('${name}', '${surname}', '${county}', ${isPatronymic})
   		RETURNING ${codeHuman};
	`
}

const checkNewHumanSql = (typeOfHuman, objHuman, newID) => {
	return`
		select *
		from ${typeOfHuman}
		where ${objHuman[0]}='${newID}'; 	
	`
}

addNewHuman = (req, callback) => {
	let objHuman, addHuman, checkID, typeOfHuman;

	if (req.namePartner != undefined) {
		const objPartner = ["codePartner", "namePartner", "surnamePartner", "Country", "patronymic"];
		typeOfHuman = 'Partners';
		objHuman = objPartner;
		addHuman = addNewHumanSql(typeOfHuman, objHuman, req.namePartner,
			req.surnamePartner, req.patronymicPartner, req.countryPartner);
	} else if (req.nameShepartner != undefined) {
		const objShepartner = ["codeShePartner", "nameShePartner", "surnameShePartner", "Country", "patronymic"];
		typeOfHuman = 'Shepartners';
		objHuman = objShepartner;
		addHuman = addNewHumanSql(typeOfHuman, objHuman, req.nameShepartner,
			req.surnameShepartner, req.patronymicShepartner, req.countryShepartner);
	} else if (req.nameCoach != undefined) {
		const objCoach = ["codeCoach", "nameCoach", "surnameCoach", "Country", "patronymicCoaches"];
		typeOfHuman = 'Coaches';
		objHuman = objCoach;
		addHuman = addNewHumanSql(typeOfHuman, objHuman, req.nameCoach,
			req.surnameCoach, req.patronymicCoach, req.countryCoach);
	} else {
		console.log('error');
	}

	console.log("В базе", addHuman);

	queryDB(addHuman)
		.then(
			rs => {
				disconnectFromDB();
				console.log('aaaa', rs);
				let checkHuman;
				for (key in rs) {
	        		checkHuman = checkNewHumanSql(typeOfHuman, objHuman, rs[key]);
				}
	        	console.log("передпоследний", checkHuman);
	        	return checkHuman;
			},
			err => {
				console.log(err);
	        	disconnectFromDB();
			})
		.then(checkHuman => queryDB(checkHuman))
		.then(
			rs => {
	        	disconnectFromDB();
				callback(rs);
			},
			err => {
				console.log(err);
				callback(err);
	        	disconnectFromDB();
			})
		.catch(error => {
			console.error(error);
			callback(error);
		});
}

module.exports = {
	addNewHuman: addNewHuman
}