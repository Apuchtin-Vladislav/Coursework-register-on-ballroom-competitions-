const Firebird = require('node-firebird');
const Promise = require('bluebird');
var db;

const options = {
	database: 'D:/Pars/3 course/2 semester/DataBase/Coursework/git_Coursework/public/bd/COURSEWORK_VER2.FDB',
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

const getAllID = (checkID, objHuman, typeOfHuman, req) => {
	const def = Promise.defer();
	let checkHuman, addHuman, newID, allID = [];

	connectToDB(options).then(
	  	// success
	  	dbconn => {
			db = dbconn;
			db.query(checkID, (err, rs) => {
				if (err) {
					def.reject(err);
				} else {
					rs.forEach(item => {
						allID.push(parseInt(ab2str(item.CODEPARTNER), 10));
					});
					newID = Math.max.apply(null, allID) + 1;
					addHuman = addNewHumanSql(typeOfHuman, objHuman, req.namePartner,
						req.surnamePartner, req.countryPartner, req.patronymicPartner, newID);
					console.log("В базе", allID, newID, checkID, addHuman);
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


const addNewHumanSql = (typeOfHuman, objHuman, name, surname, county, patronymic, newID) => {
	const isPatronymic = patronymic === "" ? 'null' : `'${patronymic}'`;
	let parseObj = ``;
	let codeHuman = objHuman[0];
	objHuman.forEach((item) => {
		if (objHuman[objHuman.length - 1] == item) {
			parseObj += item;
		} else {
			parseObj += item + ', '; 
		}
	});
	return`
		INSERT INTO ${typeOfHuman} (${parseObj})
   		VALUES (${newID}, '${name}', '${surname}', '${county}', ${isPatronymic})
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

const checkEmptyIndex = (typeOfHuman, objHuman) => {
	return`
		select ${objHuman[0]}
		from ${typeOfHuman};
	`
}

addNewHuman = (req, callback) => {
	let objHuman, checkID, allID, typeOfHuman;

	if (req.namePartner != undefined) {
		const objPartner = ["codePartner", "namePartner", "surnamePartner", "Country", "patronymic"];
		typeOfHuman = 'Partners';
		objHuman = objPartner;
		checkID = checkEmptyIndex('Partners', objHuman);
	} else {
		console.log('error');
	}

	getAllID(checkID, objHuman, typeOfHuman, req)
		.then(
			(human) => {
				disconnectFromDB();
				return human;
			},
			err => {
				console.log(err);
	        	disconnectFromDB();
			})
		.then(human => queryDB(human))
		.then(
			rs => {
	        	disconnectFromDB();
	        	let checkHuman = checkNewHumanSql(typeOfHuman, objHuman, rs.CODEPARTNER);
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